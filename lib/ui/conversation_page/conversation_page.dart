// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/ui/const.dart';
import 'package:whatsapp_clone/viewmodel/user_model.dart';
import 'package:whatsapp_clone/widgets/center_text.dart';
import 'package:whatsapp_clone/widgets/progress_elevated_button.dart';

class ConversationPage extends StatefulWidget {
  final Conversation conversation;
  const ConversationPage({Key? key, required this.conversation})
      : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  TextEditingController controller = TextEditingController();

  bool isProgress = false;

  ScrollController scrollController = ScrollController();

  late StateSetter sendButtonState, mediaState;

  late Conversation conversation;

  String chosenMedia = "";

  FocusNode focusNode = FocusNode();

  int imageHeight = 190;

  @override
  void initState() {
    super.initState();
    conversation = widget.conversation;
  }

  @override
  void dispose() {
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(conversation.getProfileImage()),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(conversation.name!),
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    Provider.of<UserModel>(context, listen: false)
                        .user!
                        .getConversationsPictureUrl()))),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Provider.of<UserModel>(context, listen: false)
                        .messageStream(conversation.id!),
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
                onTap: () => focusNode.unfocus(),
              ),
            ),
            StatefulBuilder(
                builder: (BuildContext context, StateSetter mediaStateSetter) {
              mediaState = mediaStateSetter;
              return chosenMedia.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.file(File(chosenMedia)),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 70),
                                child: GestureDetector(
                                  child: const Icon(
                                    Icons.clear,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                  onTap: () {
                                    mediaState(() {
                                      chosenMedia = "";
                                    });
                                  },
                                ))
                          ],
                        ),
                      ),
                    )
                  : Container();
            }),
            Row(
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 40,
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
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                                hintText: "Type a message",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      InkWell(
                        child: const Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          chooseMedia(ImageSource.gallery);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            chooseMedia(ImageSource.camera);
                          },
                        ),
                      )
                    ],
                  ),
                )),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter buttonState) {
                  sendButtonState = buttonState;
                  return Container(
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor),
                    child: ProgressElevatedButton(
                      isProgress: isProgress,
                      icon: const Icon(
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
      AlignmentGeometry alignment =
          Provider.of<UserModel>(context, listen: false).user!.id! ==
                  message.senderId
              ? Alignment.centerRight
              : Alignment.bottomLeft;
      children.add(ListTile(
        title: Align(
          alignment: alignment,
          child: message.media != null && message.media!.isNotEmpty
              ? SizedBox(
                  height: 200,
                  child: Image.network(message.media!),
                )
              : Container(),
        ),
        subtitle: message.message != null
            ? Align(
                alignment: alignment,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10))),
                  child: Text(
                    message.message!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            : null,
      ));
    }
    return children;
  }

  Future chooseMedia(ImageSource imageSource) async {
    try {
      String? chosenMediaPath =
          await Provider.of<UserModel>(context, listen: false)
              .chooseMedia(imageSource);
      if (chosenMediaPath != null) {
        mediaState(() {
          chosenMedia = chosenMediaPath;
        });
      } else {
        showSnackBar(context, "Media not selected 😕", error: true);
      }
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);
    }
  }

  Future sendMessage() async {
    sendButtonState(() {
      isProgress = true;
    });

    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await Provider.of<UserModel>(context, listen: false)
          .sendMessage(conversation.id!, controller.text, chosenMedia);
      controller.text = "";
      if (chosenMedia.isNotEmpty) {
        conversation.imageCount = conversation.getImageCount() + 1;
      }
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);
    }

    sendButtonState(() {
      isProgress = false;
    });

    mediaState(() {
      chosenMedia = "";
    });

    int imageCount = conversation.getImageCount();
    if (imageCount == 0) {
      imageCount = 1;
      imageHeight = 80;
    }
    scrollController.jumpTo(
        scrollController.position.maxScrollExtent + imageCount * imageHeight);
  }
}
