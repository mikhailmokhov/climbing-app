import 'dart:async';

import 'package:climbing/services/api_service.dart';
import 'package:climbing/models/request_photo_upload_url_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:climbing/classes/user.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/utils/ErrorUtils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path/path.dart' as path;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vibrate/vibrate.dart';

class EditAccount extends StatefulWidget {
  final User user;
  final void Function(User) updateUserCallback;

  const EditAccount(
      {Key key, @required this.user, @required this.updateUserCallback})
      : super(key: key);

  @override
  EditAccountState createState() => EditAccountState();
}

class EditAccountState extends State<EditAccount> {
  final TextEditingController fullNameController = new TextEditingController();
  final TextEditingController nicknameController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BuildContext _buildContext;
  bool _widgetIsActive = false,
      _inAsyncCall = false,
      _canVibrate = false,
      _imageChanged = false;

  String _nicknameError = '', _fullNameError = '';

  File _image;
  Flushbar _flushbar;
  Timer _timer;

  String _fullNameValidator(String fullName) {
    if (_fullNameError.length > 0) {
      return _fullNameError;
    }
    return null;
  }

  String _nicknameValidator(String nickname) {
    if (_nicknameError.length > 0) {
      String error = _nicknameError;
      // disable message until after next async call
      //_nicknameError = '';
      return error;
    }
    return null;
  }

  Future<void> validateNicknameAsync(String value) async {
    String errors = await ApiService.validateNickname(value);
    if (errors.isNotEmpty) {
      setState(() {
        _nicknameError = errors;
      });
    }
  }

  Future<void> validateFullNameAsync(String value) async {
    String errors = await ApiService.validateFullName(value);
    if (errors.isNotEmpty) {
      setState(() {
        _fullNameError = errors;
      });
    }
  }

  void save(BuildContext context) async {
    if (_inAsyncCall) return;

    String fullName = fullNameController.text.trim();
    String nickname = nicknameController.text.trim();

    bool fullNameChanged = this.widget.user.name != fullName;
    bool nicknameChanged = this.widget.user.nickname != nickname;

    if (fullNameChanged) await validateFullNameAsync(fullName);
    if (nicknameChanged) await validateNicknameAsync(nickname);

    if (_formKey.currentState.validate()) {
      // Check if any data is changed at all
      if (_imageChanged || fullNameChanged || nicknameChanged) {
        // dismiss keyboard during async call
        FocusScope.of(context).requestFocus(new FocusNode());

        // Start progress spinner
        setState(() {
          _inAsyncCall = true;
        });

        // IMAGE
        if (_imageChanged) {
          try {
            String extension = path.extension(_image.path);
            _image = await FlutterNativeImage.compressImage(_image.path,
                quality: 100, targetWidth: 300, targetHeight: 300);
            RequestPhotoUploadUrlResponse requestPhotoUploadUrlResponse =
                await ApiService.requestUploadPhotoUrl(extension);
            await ApiService.uploadFile(
                requestPhotoUploadUrlResponse.url, _image);
            String newPhotoUrl = await ApiService.updatePhotoUrl(
                requestPhotoUploadUrlResponse.fileId + extension);
            this.widget.user.photoUrl = newPhotoUrl;
          } catch (e) {
            handleError(e);
            return;
          }
        }

        // Save full name and nickname
        if (fullNameChanged || nicknameChanged) {
          String oldName = this.widget.user.name;
          String oldNickname = this.widget.user.nickname;
          this.widget.user.name = fullName;
          this.widget.user.nickname = nickname;
          try {
            await ApiService.updateUser(this.widget.user);
          } catch (e) {
            this.widget.user.name = oldName;
            this.widget.user.nickname = oldNickname;
            handleError(e);
            return;
          }
        }

        // Close progress spinner
        _inAsyncCall = false;

        // Pass updated use to parent widgets
        widget.updateUserCallback(this.widget.user);
      }
      // Close dialog
      if (_widgetIsActive) Navigator.pop(context);
    }
  }

  @override
  void deactivate() {
    _widgetIsActive = false;
    super.deactivate();
  }

  @override
  initState() {
    super.initState();
    Vibrate.canVibrate.then((value) => _canVibrate = value);
    fullNameController.text = widget.user.name;
    nicknameController.text = widget.user.nickname;
  }

  void removeFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void handleError(dynamic e) {
    _inAsyncCall = true;
    _flushbar?.dismiss();
    _flushbar = Flushbar(
      message: ErrorUtils.toMessage(e),
      backgroundColor: Colors.deepOrange,
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
    )..show(_buildContext);
  }

  Future getImage(ImageSource source) async {
    try {
      var image = await ImagePicker.pickImage(source: source);
      if (image != null) {
        File croppedFile = await ImageCropper.cropImage(
            cropStyle: CropStyle.circle,
            sourcePath: image.path,
            aspectRatioPresets: [CropAspectRatioPreset.square],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: S.of(context).cropper,
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            ));
        setState(() {
          _image = croppedFile;
        });
        _imageChanged = true;
      }
    } catch (e) {
      handleError(e);
    }
  }

  void editPhoto(BuildContext context) {
    if (_canVibrate) Vibrate.feedback(FeedbackType.light);
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.camera),
                  title: new Text(S.of(context).camera),
                  onTap: () {
                    removeFocus(context);
                    getImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text(S.of(context).gallery),
                  onTap: () {
                    removeFocus(context);
                    getImage(ImageSource.gallery);
                    // dismiss the modal sheet
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _formKey.currentState?.validate();
    _widgetIsActive = true;
    _buildContext = context;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).editProfile),
        actions: <Widget>[
          FlatButton(
              child: Text(S.of(context).SAVE,
                  style:
                      theme.textTheme.bodyText1.copyWith(color: Colors.white)),
              onPressed: _inAsyncCall
                  ? null
                  : () {
                      save(context);
                    }),
        ],
      ),
      body: ModalProgressHUD(
          child: Form(
            onChanged: () {
              _formKey.currentState.validate();
            },
            key: _formKey,
            child: Scrollbar(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(
                            width: 172.0,
                            height: 172.0,
                            child: GestureDetector(
                                onTap: () {
                                  editPhoto(context);
                                },
                                child: CircleAvatar(
                                  backgroundImage: this._image != null
                                      ? FileImage(this._image)
                                      : CachedNetworkImageProvider(
                                          this.widget.user.getPictureUrl()),
                                ))),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: OutlineButton(
                              child: Text(S.of(context).editPhoto),
                              onPressed: () {
                                editPhoto(context);
                              }),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.bottomLeft,
                    child: TextFormField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        labelText: S.of(context).fullName,
                      ),
                      validator: _fullNameValidator,
                      onChanged: (String value) {
                        _fullNameError = '';
                        if (_timer != null) _timer.cancel();
                        _timer = Timer(Duration(seconds: 1), () {
                          validateFullNameAsync(value);
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.bottomLeft,
                    child: TextFormField(
                      validator: _nicknameValidator,
                      onChanged: (String value) {
                        _nicknameError = '';
                        if (_timer != null) _timer.cancel();
                        _timer = Timer(Duration(seconds: 1), () {
                          validateNicknameAsync(value);
                        });
                      },
                      controller: nicknameController,
                      decoration: InputDecoration(
                        labelText: S.of(context).nickname,
                        alignLabelWithHint: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          inAsyncCall: _inAsyncCall),
    );
  }
}
