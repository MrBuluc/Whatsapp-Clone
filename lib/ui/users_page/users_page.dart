// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/ui/const.dart';
import 'package:whatsapp_clone/ui/home_page/home_page.dart';
import 'package:whatsapp_clone/viewmodel/user_model.dart';
import 'package:whatsapp_clone/widgets/progress_elevated_button.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  TextStyle textStyle = const TextStyle(fontSize: 20);

  bool isProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProgressElevatedButton(
                    isProgress: isProgress,
                    text: "Hakkıcan",
                    onPressed: () {
                      goToPage("BVA0lcxdREjYukUQisLM");
                    }),
                ProgressElevatedButton(
                    isProgress: isProgress,
                    text: "Reyhan",
                    onPressed: () {
                      goToPage("OcWHKUED3pcDmYzVpmMt");
                    })
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ProgressElevatedButton(
                isProgress: isProgress,
                text: "Dilan",
                onPressed: () {
                  goToPage("aQ5eGxv7Ao7csTTPxqQH");
                })
          ],
        ),
      ),
    );
  }

  goToPage(String userId) async {
    setState(() {
      isProgress = true;
    });

    try {
      await Provider.of<UserModel>(context, listen: false)
          .getUser(userId, false);

      setState(() {
        isProgress = false;
      });

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);
    }
  }
}
