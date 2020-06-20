import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/api/api.dart' as api;
import 'package:climbing/models/app_state.dart';
import 'package:climbing/models/request_photo_upload_url_response.dart';
import 'package:climbing/utils/utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as path;
import 'package:vibrate/vibrate.dart';

import '../typedefs.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(
      {Key key, @required this.appState, @required this.updateUser, @required this.feedback})
      : super(key: key);

  static const String routeName = '/profile';

  final AppState appState;
  final UpdateUserCallback updateUser;
  final FeedbackCallback feedback;

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  static const int SERVER_VALIDATE_DELAY_MILLS = 500;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BuildContext _buildContext;
  bool _widgetIsActive = false,
      _inAsyncCall = false,
      _imageChanged = false;

  String _nicknameError = '', _fullNameError = '';

  File _image;
  Flushbar<void> _flushbar;
  Timer _timer;

  String _fullNameValidator(String fullName) {
    if (_fullNameError.isNotEmpty) {
      return _fullNameError;
    }
    return null;
  }

  String _nicknameValidator(String nickname) {
    if (_nicknameError.isNotEmpty) {
      final String error = _nicknameError;
      return error;
    }
    return null;
  }

  Future<void> validateNicknameAsync(String value) async {
    final String errors = await api.validateNickname(value);
    if (errors.isNotEmpty) {
      setState(() {
        _nicknameError = errors;
      });
    }
  }

  Future<void> validateFullNameAsync(String value) async {
    final String errors = await api.validateFullName(value);
    if (errors.isNotEmpty) {
      setState(() {
        _fullNameError = errors;
      });
    }
  }

  Future<void> save(BuildContext context) async {
    if (_inAsyncCall) {
      return;
    }

    final String fullName = fullNameController.text.trim();
    final String nickname = nicknameController.text.trim();

    final bool fullNameChanged = widget.appState.user.name != fullName;
    final bool nicknameChanged = widget.appState.user.nickname != nickname;

    if (fullNameChanged) {
      await validateFullNameAsync(fullName);
    }
    if (nicknameChanged) {
      await validateNicknameAsync(nickname);
    }

    if (_formKey.currentState.validate()) {
      // Check if any data is changed at all
      if (_imageChanged || fullNameChanged || nicknameChanged) {
        // dismiss keyboard during async call
        FocusScope.of(context).requestFocus(FocusNode());

        // Start progress spinner
        setState(() {
          _inAsyncCall = true;
        });

        // IMAGE
        if (_imageChanged) {
          try {
            final String extension = path.extension(_image.path);
            _image = await FlutterNativeImage.compressImage(_image.path,
                quality: 100, targetWidth: 300, targetHeight: 300);
            final RequestPhotoUploadUrlResponse requestPhotoUploadUrlResponse =
                await api.requestUploadPhotoUrl(extension);
            await api.uploadFileToSpaces(requestPhotoUploadUrlResponse.url, _image);
            final String newPhotoUrl = await api.updatePhotoUrl(
                requestPhotoUploadUrlResponse.fileId + extension);
            widget.appState.user.photoPath = newPhotoUrl;
          } catch (e) {
            handleError(e);
            return;
          }
        }

        // Save full name and nickname
        if (fullNameChanged || nicknameChanged) {
          widget.appState.user.name = fullName;
          widget.appState.user.nickname = nickname;
          try {
            await api.updateUser(fullName: fullName, nickname: nickname);
          } catch (e) {
            handleError(e);
            return;
          }
        }

        // Close progress spinner
        _inAsyncCall = false;

        // Pass updated use to parent widgets
        widget.updateUser(name: fullName, nickname: nickname);
      }
      // Close dialog
      if (_widgetIsActive) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void deactivate() {
    _widgetIsActive = false;
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.appState.user.name;
    nicknameController.text = widget.appState.user.nickname;
  }

  void removeFocus(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void handleError(dynamic e) {
    _inAsyncCall = true;
    Utils.showError(_flushbar, e, _buildContext);
  }

  Future<void> getImage(ImageSource source) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final PickedFile image = await imagePicker.getImage(source: source);
      if (image != null) {
        final File croppedFile = await ImageCropper.cropImage(
            cropStyle: CropStyle.circle,
            sourcePath: image.path,
            aspectRatioPresets: <CropAspectRatioPreset>[
              CropAspectRatioPreset.square
            ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: S.of(context).cropper,
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: false),
            iosUiSettings: const IOSUiSettings(
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
    widget.feedback(FeedbackType.selection);
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: Text(S.of(context).camera),
                  onTap: () {
                    removeFocus(context);
                    getImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: Text(S.of(context).gallery),
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
                      children: <Widget>[
                        SizedBox(
                            width: 172.0,
                            height: 172.0,
                            child: GestureDetector(
                                onTap: () {
                                  editPhoto(context);
                                },
                                child: CircleAvatar(
                                  backgroundImage: _image != null
                                      ? FileImage(_image) as ImageProvider<dynamic>
                                      : CachedNetworkImageProvider(
                                          widget.appState.user.getPictureUrl()),
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
                        if (_timer != null) {
                          _timer.cancel();
                        }
                        _timer = Timer(
                            const Duration(
                                milliseconds: EditProfileScreenState
                                    .SERVER_VALIDATE_DELAY_MILLS), () {
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
                        if (_timer != null) {
                          _timer.cancel();
                        }
                        _timer = Timer(
                            const Duration(
                                milliseconds: EditProfileScreenState
                                    .SERVER_VALIDATE_DELAY_MILLS), () {
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
