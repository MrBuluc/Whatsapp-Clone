import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/ui/conversation_page/conversation_page.dart';
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
    return StreamBuilder<List<Conversation>>(
      stream: Provider.of<UserModel>(context, listen: false).getConversations(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Conversation>> snapshot) {
        if (snapshot.hasError) {
          return CenterText(text: snapshot.error.toString());
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

  List<ListTile> buildListView(AsyncSnapshot<List<Conversation>> snapshot) {
    List<Conversation> conversations = snapshot.data!;

    List<ListTile> children = [];
    for (Conversation conversation in conversations) {
      children.add(ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(conversation.getProfileImage()),
        ),
        title: Text(conversation.name!),
        subtitle: Text(conversation.displayMessage!),
        trailing: Text(conversation.timeConverter()),
        onTap: () {
          Provider.of<UserModel>(context, listen: false)
              .navigateTo(ConversationPage(
            conversation: conversation,
          ));
        },
      ));
    }
    return children;
  }
}
