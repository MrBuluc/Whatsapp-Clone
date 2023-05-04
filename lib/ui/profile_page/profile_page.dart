import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/services/validator.dart';
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

  String picturePath = "", conversationPicturePath = "";

  late User user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserModel>(context, listen: false).user!;
    currentUser();
  }

  currentUser() {
    nameCnt.text = user.name!;
    surnameCnt.text = user.surname!;
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: Picture(
                      imgUrl: user.pictureUrl,
                      height: 150,
                      width: 150,
                    ),
                  ),
                  GestureDetector(
                    child: Picture(
                      imgUrl: user.getConversationsPictureUrl(),
                      height: 200,
                      width: 150,
                    ),
                  )
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .65,
                            child: ProgressElevatedButton(
                              isProgress: isProgress,
                              text: "Save Profile Information",
                              backgroundColor: changed
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context).focusColor,
                              onPressed: () {},
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    ));
  }

  Widget buildTextFormField(TextEditingController controller, String label,
          {double top = 0}) =>
      Container(
        padding: EdgeInsets.only(top: top, left: 15, right: 30),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              labelText: label, prefixIcon: Icon(Icons.perm_identity)),
          validator: (String? value) => Validator.textControl(value, label),
          onChanged: (String value) => changed = true,
        ),
      );
}
