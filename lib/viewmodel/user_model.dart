import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/locator.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/repository/user_repository.dart';

import '../ui/const.dart';

class UserModel with ChangeNotifier {
  final UserRepository _userRepository = locator<UserRepository>();
  User? user;

  Stream<List<Conversation>> getConversations() {
    try {
      return _userRepository.getConversations(user!.id!);
    } catch (e) {
      classPrintError("conversationsStreamMembersContains", e);
      rethrow;
    }
  }

  Future<User?> getUser(String id, bool isOther) async {
    try {
      User? localUser = await _userRepository.getUser(id);
      if (!isOther) {
        user = localUser;
        return user;
      }
      return localUser;
    } catch (e) {
      classPrintError("getUser", e);
      rethrow;
    }
  }

  Future<bool> updateUser(User updatedUser, String picturePath,
      String conversationPicturePath) async {
    try {
      User? resultUser = await _userRepository.updateUser(
          updatedUser, picturePath, conversationPicturePath);
      if (resultUser != null) {
        user = resultUser;
        return true;
      }
      return false;
    } catch (e) {
      classPrintError("updateUser", e);
      rethrow;
    }
  }

  Stream<QuerySnapshot> messageStream(String conversationId) {
    try {
      return _userRepository.messageStream(conversationId);
    } catch (e) {
      classPrintError("messageStream", e);
      rethrow;
    }
  }

  Future<bool> sendMessage(
      String conversationId, String message, String chosenMedia) async {
    try {
      return await _userRepository.sendMessage(conversationId,
          Message(message: message, senderId: user!.id!), chosenMedia);
    } catch (e) {
      classPrintError("sendMessage", e);
      rethrow;
    }
  }

  Future<String?> uploadMedia(String conversationId, String mediaPath) async {
    try {
      return await _userRepository.uploadMedia(conversationId, mediaPath);
    } catch (e) {
      classPrintError("uploadMedia", e);
      rethrow;
    }
  }

  Future<String?> chooseMedia(ImageSource imageSource) async {
    try {
      return await _userRepository.chooseMedia(imageSource);
    } catch (e) {
      classPrintError("chooseMedia", e);
      rethrow;
    }
  }

  classPrintError(String methodName, Object e) {
    printError("UserModel", methodName, e);
  }
}
