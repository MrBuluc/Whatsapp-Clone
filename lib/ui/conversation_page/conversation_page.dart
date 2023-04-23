import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/ui/const.dart';
import 'package:whatsapp_clone/viewmodel/user_model.dart';
import 'package:whatsapp_clone/widgets/center_text.dart';
import 'package:whatsapp_clone/widgets/progress_elevated_button.dart';

class ConversationPage extends StatefulWidget {
  final String conversationId;
  const ConversationPage({Key? key, required this.conversationId})
      : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  TextEditingController controller = TextEditingController();

  bool isProgress = false;

  ScrollController scrollController = ScrollController();

  late StateSetter sendButtonState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Row(
          children: const [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/128009228/original/8e8ad34b012b46ebd403bd4157f8fef6bb2c076b/design-minimalist-flat-cartoon-caricature-avatar-in-6-hours.jpg"),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text("data"),
            )
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://i.pinimg.com/originals/52/e5/6f/52e56fb927b170294ccc035f02c6477d.jpg"))),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: Provider.of<UserModel>(context, listen: false)
                      .messageStream(widget.conversationId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const CenterText(text: "Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView(
                      controller: scrollController,
                      children: buildListView(snapshot),
                    );
                  }),
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(25),
                          right: Radius.circular(25))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(
                                hintText: "Type a message",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      const InkWell(
                        child: Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: InkWell(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter buttonState) {
                  sendButtonState = buttonState;
                  return Container(
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor),
                    child: ProgressElevatedButton(
                      isProgress: isProgress,
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        sendMessage();
                      },
                    ),
                  );
                })
              ],
            )
          ],
        ),
      ),
    );
  }

  List<ListTile> buildListView(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    List<Message> messages = snapshot.data!.docs
        .map((DocumentSnapshot document) => document.data()! as Message)
        .toList();

    List<ListTile> children = [];
    for (Message message in messages) {
      children.add(ListTile(
        title: Align(
          alignment: message.senderId! !=
                  Provider.of<UserModel>(context, listen: false).user!.id!
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(10), right: Radius.circular(10))),
              child: Text(
                message.message!,
                style: const TextStyle(color: Colors.white),
              )),
        ),
      ));
    }
    return children;
  }

  Future sendMessage() async {
    sendButtonState(() {
      isProgress = true;
    });

    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await Provider.of<UserModel>(context, listen: false)
          .sendMessage(widget.conversationId, controller.text);
      controller.text = "";
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);
    }

    sendButtonState(() {
      isProgress = false;
    });

    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}
