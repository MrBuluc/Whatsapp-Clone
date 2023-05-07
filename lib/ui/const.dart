// ignore_for_file: avoid_print
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle textStyle = const TextStyle(fontSize: 20);

const String usersCollectionName = "Users",
    userProfilePictureFileName = "profilePicture.jpg",
    userConversationPictureFileName = "conversationPicture.jpg",
    userProfilePictureFieldName = "pictureUrl",
    userConversationsPictureFieldName = "conversationsPictureUrl";

const String defaultProfilePictureUrl =
        "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/128009228/original/8e8ad34b012b46ebd403bd4157f8fef6bb2c076b/design-minimalist-flat-cartoon-caricature-avatar-in-6-hours.jpg",
    defaultConversationPictureUrl =
        "https://i.pinimg.com/originals/52/e5/6f/52e56fb927b170294ccc035f02c6477d.jpg";

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
