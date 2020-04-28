import 'package:cached_network_image/cached_network_image.dart';
import 'package:climbing/classes/user.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:climbing/services/api_service.dart';
import 'package:path/path.dart' as path;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class EditAccount extends StatefulWidget {
  final User user;
  final Future<bool> Function(User) updateUser;

  const EditAccount({Key key, @required this.user, @required this.updateUser})
      : super(key: key);

  @override
  EditAccountState createState() => EditAccountState();
}

class EditAccountState extends State<EditAccount> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File _image;
  var _dialog;
  bool imageChanged = false;
  Flushbar flushbar;

  void updateAndClose(user) {
    _dialog = showProgressDialog(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
        loadingText: "",
        context: context);
    widget.updateUser(user).whenComplete(() {
      dismissProgressDialog();
      Navigator.pop(context, DismissDialogAction.save);
    });
  }

  void removeFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void dismissProgressDialog() {
    _dialog.dismiss();
  }

  void showError(String error, BuildContext context) {
    flushbar?.dismiss();
    flushbar = Flushbar(
      message: error,
      backgroundColor: Colors.deepOrange,
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    )..show(context);
  }

  void attemptToSave(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      if (imageChanged) {
        String extension = path.extension(_image.path);
        _dialog = showProgressDialog(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
            loadingText: S.of(context).saving,
            context: context);
        _image = await FlutterNativeImage.compressImage(_image.path,
            quality: 100, targetWidth: 300, targetHeight: 300);
        ApiService.requestUploadPhotoUrl(extension).then((response) {
          ApiService.uploadFile(response.url, _image).then((_) {
            ApiService.updatePhotoUrl(response.fileId + extension)
                .then((String url) {
              User user = this.widget.user;
              user.photoUrl = url;
              dismissProgressDialog();
              updateAndClose(user);
            }).catchError((Object error) {
              dismissProgressDialog();
              showError(error.toString(), context);
            });
          }).catchError((Object error) {
            dismissProgressDialog();
            showError(error.toString(), context);
          });
        }).catchError((Object error) {
          dismissProgressDialog();
          showError(error.toString(), context);
        });
      } else if (this.widget.user.name != nameController.text ||
          this.widget.user.nickname != userNameController.text) {
        User user = this.widget.user;
        user.name = nameController.text;
        user.nickname = userNameController.text;
        updateAndClose(user);
      } else {
        Navigator.pop(context, DismissDialogAction.save);
      }
    }
  }

  @override
  initState() {
    super.initState();
    assert(widget.user.name is String);
    nameController.text = widget.user.name;
    userNameController.text = widget.user.nickname;
  }

  Future getImage(ImageSource source) async {
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
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).editProfile),
        actions: <Widget>[
          FlatButton(
            child: Text(S.of(context).SAVE,
                style: theme.textTheme.bodyText1.copyWith(color: Colors.white)),
            onPressed: () {
              attemptToSave(context);
            },
          ),
        ],
      ),
      body: Form(
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
                child: SizedBox(
                    width: 172.0,
                    height: 172.0,
                    child: GestureDetector(
                        onTap: () {
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
                        },
                        child: CircleAvatar(
                          backgroundImage: this._image != null
                              ? FileImage(this._image)
                              : CachedNetworkImageProvider(
                                  this.widget.user.getPictureUrl()),
                        ))),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                alignment: Alignment.bottomLeft,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: S.of(context).fullName,
                    filled: false,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                alignment: Alignment.bottomLeft,
                child: TextFormField(
                  validator: (String value) {
                    if (value.isEmpty) {
                      return S.of(context).usernameCanNotBeEmpty;
                    } else if (value.contains(' ')) {
                      return S.of(context).usernameCanNotContainSpaces;
                    } else {
                      return null;
                    }
                  },
                  controller: userNameController,
                  decoration: InputDecoration(
                    labelText: S.of(context).username,
                    alignLabelWithHint: false,
                    filled: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
