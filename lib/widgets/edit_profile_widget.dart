import 'package:cached_network_image/cached_network_image.dart';
import 'package:climbing/classes/user_class.dart';
import 'package:climbing/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker_ui/image_picker_handler.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class EditAccount extends StatefulWidget {
  final User user;
  final Function updateProfile;

  const EditAccount(
      {Key key, @required this.user, @required this.updateProfile})
      : super(key: key);

  @override
  EditAccountState createState() => EditAccountState();
}

class EditAccountState extends State<EditAccount>
    with TickerProviderStateMixin, ImagePickerListener {
  TextEditingController nameController = new TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  FocusNode nameFocusNode = new FocusNode();
  final _formKey = GlobalKey<FormState>();
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  @override
  userImage(File _image) {
//    ImageCropper.cropImage(
//      sourcePath: _image.path,
//      ratioX: 1.0,
//      ratioY: 1.0,
//      maxWidth: 512,
//      maxHeight: 512,
//    ).then((File _image) {
//      setState(() {
//        this._image = _image;
//      });
//    });
  }

  @override
  initState() {
    super.initState();
    nameController.text = widget.user.name;
    userNameController.text = widget.user.username;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(nameFocusNode);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = ImagePickerHandler(this, _controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                style: theme.textTheme.body2.copyWith(color: Colors.white)),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                widget.updateProfile(
                    nameController.text, userNameController.text);
                Navigator.pop(context, DismissDialogAction.save);
              }
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
                          imagePicker.showDialog(context);
                        },
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              this.widget.user.getPictureUrl()),
                        ))),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                alignment: Alignment.bottomLeft,
                child: TextField(
                  controller: nameController,
                  focusNode: nameFocusNode,
                  decoration: InputDecoration(
                    labelText: S.of(context).name,
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
