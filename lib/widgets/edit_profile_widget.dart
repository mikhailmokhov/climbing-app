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
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController nicknameController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image;
  bool imageChanged = false;
  Flushbar _flushbar;
  BuildContext _buildContext;
  bool _controlsEnabled = true;
  bool _active;
  bool _inAsyncCall = false;
  Timer _timer;

  String _asyncNicknameValidationErrorMessage = '';

  String _fullName;
  String _nickname;

  // Validate full name
  String _validateFullName(String fullName) {
    fullName = fullName.trim();
    if (fullName.length > 20) {
      return 'Name must be less than 20 characters';
    }
    return null;
  }

  // Validate nickname
  String _prevalidateNickname(String nickname) {
    if (_asyncNicknameValidationErrorMessage.length > 0) {
      String error = _asyncNicknameValidationErrorMessage;
      // disable message until after next async call
      _asyncNicknameValidationErrorMessage = '';
      return error;
    }
    return null;
  }

  void removeFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void handleError(dynamic e) {
//    setState(() {
//      _controlsEnabled = true;
//    });
    _inAsyncCall = true;
    //dismissProgressDialog();
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

  void save(BuildContext context) async {
    if (_inAsyncCall) return;
    print("Saving!!!");

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // dismiss keyboard during async call ?????
      FocusScope.of(context).requestFocus(new FocusNode());

      bool fullNameChanged = this.widget.user.name != _fullName;
      bool nicknameChanged = this.widget.user.nickname != _nickname;

      // Check if any data is changed
      if (imageChanged || fullNameChanged || nicknameChanged) {
        // Start progress spinner
        setState(() {
          _inAsyncCall = true;
        });

        if (nicknameChanged && !await isNicknameValid(_nickname)) return;

        // IMAGE
        if (imageChanged) {
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

        // TEXT FIELDS
        if (nicknameChanged || nicknameChanged) {
          String oldName = this.widget.user.name;
          String oldNickname = this.widget.user.nickname;
          this.widget.user.name = _fullName;
          this.widget.user.nickname = _nickname;
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
      if (_active) Navigator.pop(context);
    }
  }

  @override
  void deactivate() {
    _active = false;
    super.deactivate();
  }

  @override
  initState() {
    super.initState();
    nameController.text = widget.user.name;
    nicknameController.text = widget.user.nickname;
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
        imageChanged = true;
      }
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> isNicknameValid(String value) async {
    _asyncNicknameValidationErrorMessage =
        await ApiService.validateNickname(value);
    if (_asyncNicknameValidationErrorMessage != null &&
        _asyncNicknameValidationErrorMessage.length > 0) {
      setState(() {
        _inAsyncCall = false;
      });
      return false;
    }
    return true;
  }

  void editPhoto(BuildContext context) {
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
    _active = true;
    _buildContext = context;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).editProfile),
        actions: <Widget>[
          FlatButton(
            child: Text(S.of(context).SAVE,
                style: theme.textTheme.bodyText1.copyWith(color: Colors.white)),
            onPressed: _controlsEnabled
                ? () {
                    save(context);
                  }
                : null,
          ),
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
                                onTap: _controlsEnabled
                                    ? () {
                                        editPhoto(context);
                                      }
                                    : null,
                                child: CircleAvatar(
                                  backgroundImage: this._image != null
                                      ? FileImage(this._image)
                                      : CachedNetworkImageProvider(
                                          this.widget.user.getPictureUrl()),
                                ))),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: OutlineButton(
                              child: Text(S.of(context).editPhoto,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryIconTheme
                                          ?.color)),
                              onPressed: _controlsEnabled
                                  ? () {
                                      editPhoto(context);
                                    }
                                  : null),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.bottomLeft,
                    child: TextFormField(
                      enabled: _controlsEnabled,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: S.of(context).fullName,
                      ),
                      validator: _validateFullName,
                      onSaved: (value) => _fullName = value.trim(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.bottomLeft,
                    child: TextFormField(
                      enabled: _controlsEnabled,
                      validator: _prevalidateNickname,
                      onSaved: (String value) => _nickname = value.trim(),
                      onChanged: (String value) {
                        if (_timer != null) _timer.cancel();
                        _timer = Timer(Duration(seconds: 1), () {
                          isNicknameValid(value);
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
