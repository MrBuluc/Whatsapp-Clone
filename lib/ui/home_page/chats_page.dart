import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/model/chat.dart';
import 'package:whatsapp_clone/viewmodel/user_model.dart';
import 'package:whatsapp_clone/widgets/center_text.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Provider.of<UserModel>(context, listen: false).chatsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const CenterText(text: "Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: buildListView(snapshot),
        );
      },
    );
  }

  List<ListTile> buildListView(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    List<Chat> chats = snapshot.data!.docs
        .map((DocumentSnapshot document) => document.data()! as Chat)
        .toList();

    List<ListTile> children = [];
    for (Chat chat in chats) {
      children.add(ListTile(
        title: Text(chat.name!),
        subtitle: Text(chat.message!),
        trailing: Text(chat.timeConverter()),
      ));
    }
    return children;
  }
}
