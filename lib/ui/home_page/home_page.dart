import 'package:flutter/material.dart';
import 'package:whatsapp_clone/ui/home_page/camera_page.dart';
import 'package:whatsapp_clone/ui/home_page/chats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  bool showMessage = true;

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
      appBar: AppBar(
        title: const Text("Whatsapp Clone"),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.camera),
            ),
            Tab(
              text: "Chats",
            ),
          ],
        ),
      ),
      floatingActionButton: showMessage
          ? FloatingActionButton(
              child: const Icon(Icons.message),
              onPressed: () {},
            )
          : null,
      body: TabBarView(
        controller: tabController,
        children: const [CameraPage(), ChatsPage()],
      ),
    );
  }
}
