import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/ui/home_page/camera_page.dart';
import 'package:whatsapp_clone/ui/home_page/chats_page.dart';
import 'package:whatsapp_clone/ui/home_page/contacts_page.dart';
import 'package:whatsapp_clone/ui/profile_page/profile_page.dart';
import 'package:whatsapp_clone/viewmodel/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  bool showMessage = true;

  List<CustomPopupMenu> choices = [CustomPopupMenu(index: 0, title: "Profile")];

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    tabController.addListener(() {
      showMessage = tabController.index != 0;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showMessage
          ? FloatingActionButton(
              child: const Icon(Icons.message),
              onPressed: () {
                Provider.of<UserModel>(context, listen: false)
                    .navigateTo(const ContactsPage());
              },
            )
          : null,
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                title: const Text("Whatsapp Clone"),
                actions: [
                  PopupMenuButton<CustomPopupMenu>(
                    elevation: 3.2,
                    onSelected: selectChoice,
                    itemBuilder: (BuildContext context) => choices
                        .map((CustomPopupMenu choice) =>
                            PopupMenuItem<CustomPopupMenu>(
                              value: choice,
                              child: Text(choice.title),
                            ))
                        .toList(),
                  )
                ],
              )
            ],
            body: Column(
              children: [
                TabBar(
                  controller: tabController,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.camera),
                    ),
                    Tab(
                      text: "Chats",
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: TabBarView(
                      controller: tabController,
                      children: const [CameraPage(), ChatsPage()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  selectChoice(CustomPopupMenu choice) {
    if (choice.index == 0) {
      Provider.of<UserModel>(context, listen: false)
          .navigateTo(const ProfilePage());
    }
  }
}

class CustomPopupMenu {
  int index;
  String title;

  CustomPopupMenu({required this.index, required this.title});
}
