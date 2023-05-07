// ignore_for_file: avoid_print
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle textStyle = const TextStyle(fontSize: 20);

const String usersCollectionName = "Users",
    userProfilePictureFileName = "profilePicture.jpg",
    userConversationPictureFileName = "conversationPicture.jpg",
    userProfilePictureFieldName = "pictureUrl",
    userConversationsPictureFieldName = "conversationsPictureUrl";

showSnackBar(BuildContext context, String content, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: error ? Colors.red : null,
    content: Text(content),
    duration: const Duration(seconds: 2),
  ));
}

printError(String className, String methodName, Object e) {
  print("$className $methodName hata: ${e.toString()}");
}
