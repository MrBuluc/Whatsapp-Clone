// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/services/validator.dart';
import 'package:whatsapp_clone/ui/const.dart';
import 'package:whatsapp_clone/viewmodel/user_model.dart';
import 'package:whatsapp_clone/widgets/picture.dart';
import 'package:whatsapp_clone/widgets/progress_elevated_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameCnt = TextEditingController(),
      surnameCnt = TextEditingController();

  bool changed = false, isProgress = false;

  late String? picturePath, conversationPicturePath;

  late User user;

  late StateSetter pictureState, conversationPictureState, buttonState;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserModel>(context, listen: false).user!;
    currentUser();
  }

  currentUser() {
    nameCnt.text = user.name!;
    surnameCnt.text = user.surname!;
    picturePath = user.pictureUrl;
    conversationPicturePath = user.getConversationsPictureUrl();
  }

  @override
  void dispose() {
    nameCnt.dispose();
    surnameCnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatefulBuilder(builder:
                      (BuildContext context, StateSetter pictureStateSetter) {
                    pictureState = pictureStateSetter;
                    return GestureDetector(
                      child: Picture(
                        imgUrl: picturePath,
                        height: 150,
                        width: 150,
                      ),
                      onTap: () {
                        chooseImage(0);
                      },
                    );
                  }),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter stateSetter) {
                    conversationPictureState = stateSetter;
                    return GestureDetector(
                      child: Picture(
                        imgUrl: conversationPicturePath,
                        height: 200,
                        width: 150,
                      ),
                      onTap: () {
                        chooseImage(1);
                      },
                    );
                  })
                ],
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 15, right: 15, top: 20, bottom: 15),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Profile Information",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        buildTextFormField(nameCnt, "Name"),
                        buildTextFormField(surnameCnt, "Surname"),
                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter stateSetter) {
                          buttonState = stateSetter;
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .65,
                                  child: ProgressElevatedButton(
                                    isProgress: isProgress,
                                    text: "Save Profile Information",
                                    backgroundColor: changed
                                        ? Theme.of(context).primaryColorDark
                                        : Theme.of(context).focusColor,
                                    onPressed: () {
                                      if (changed) {
                                        saveInformation();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              ProgressElevatedButton(
                                  isProgress: isProgress,
                                  text: "Default Profile Picture",
                                  onPressed: () {
                                    defaultProfileField(0);
                                  }),
                              ProgressElevatedButton(
                                  isProgress: isProgress,
                                  text: "Default Conversations Picture",
                                  onPressed: () {
                                    defaultProfileField(1);
                                  })
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    ));
  }

  Future chooseImage(int mode) async {
    try {
      String? chosenImagePath =
          await Provider.of<UserModel>(context, listen: false)
              .chooseMedia(ImageSource.gallery);
      if (chosenImagePath != null) {
        if (mode == 0) {
          pictureState(() {
            picturePath = chosenImagePath;
          });
        } else {
          conversationPictureState(() {
            conversationPicturePath = chosenImagePath;
          });
        }
        buttonState(() {
          changed = true;
        });
      } else {
        showSnackBar(context, "Media not selected 😕", error: true);
      }
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);
    }
  }

  Widget buildTextFormField(TextEditingController controller, String label,
          {double top = 0}) =>
      Container(
        padding: EdgeInsets.only(top: top, left: 15, right: 30),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              labelText: label, prefixIcon: const Icon(Icons.perm_identity)),
          validator: (String? value) => Validator.textControl(value, label),
          onChanged: (String value) => buttonState(() {
            changed = true;
          }),
        ),
      );

  Future saveInformation() async {
    if (formKey.currentState!.validate()) {
      buttonState(() {
        isProgress = true;
      });

      try {
        User updatedUser = User();
        UserModel userModel = Provider.of<UserModel>(context, listen: false);

        if (picturePath != user.pictureUrl) {
          updatedUser.pictureUrl =
              await userModel.uploadProfilePicture(picturePath!);
        }
        if (conversationPicturePath != user.getConversationsPictureUrl()) {
          updatedUser.conversationsPictureUrl = await userModel
              .uploadConversationPicture(conversationPicturePath!);
        }

        updatedUser.name = nameCnt.text;
        updatedUser.surname = surnameCnt.text;

        bool result = await userModel.updateUser(updatedUser);
        if (result) {
          showSnackBar(context, "Profile info has been successfully updated");
        }
      } catch (e) {
        showSnackBar(context, e.toString(), error: true);
      }

      buttonState(() {
        isProgress = false;
      });
    } else {
      showSnackBar(context, "Enter the valid values", error: true);
    }
  }

  Future defaultProfileField(int mode) async {
    buttonState(() {
      isProgress = true;
    });

    try {
      late String fileName, fieldName;
      if (mode == 0) {
        fileName = userProfilePictureFileName;
        fieldName = userProfilePictureFieldName;
      } else {
        fileName = userConversationPictureFileName;
        fieldName = userConversationsPictureFieldName;
      }
      bool result = await Provider.of<UserModel>(context, listen: false)
          .deleteUserFileField(fileName, fieldName);
      if (result) {
        if (mode == 0) {
          pictureState(() {
            picturePath = null;
          });
        } else {
          conversationPictureState(() {
            conversationPicturePath = user.getConversationsPictureUrl();
          });
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);
    }

    buttonState(() {
      isProgress = false;
    });
  }
}
