// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/locator.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/repository/user_repository.dart';

class UserModel with ChangeNotifier {
  final UserRepository _userRepository = locator<UserRepository>();
  User? user;

  Stream<List<Conversation>> getConversations() {
    try {
      return _userRepository.getConversations(user!.id!);
    } catch (e) {
      printError("conversationsStreamMembersContains", e);
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
      printError("getUser", e);
      rethrow;
    }
  }

  Stream<QuerySnapshot> messageStream(String conversationId) {
    try {
      return _userRepository.messageStream(conversationId);
    } catch (e) {
      printError("messageStream", e);
      rethrow;
    }
  }

  Future<bool> sendMessage(
      String conversationId, String message, String chosenMedia) async {
    try {
      return await _userRepository.sendMessage(conversationId,
          Message(message: message, senderId: user!.id!), chosenMedia);
    } catch (e) {
      printError("sendMessage", e);
      rethrow;
    }
  }

  Future<String?> uploadMedia(String conversationId, String mediaPath) async {
    try {
      return await _userRepository.uploadMedia(conversationId, mediaPath);
    } catch (e) {
      printError("uploadMedia", e);
      rethrow;
    }
  }

  Future<String?> chooseMedia(ImageSource imageSource) async {
    try {
      return await _userRepository.chooseMedia(imageSource);
    } catch (e) {
      printError("chooseMedia", e);
      rethrow;
    }
  }

  printError(String methodName, Object e) {
    print("Usermodel $methodName hata: $e");
  }
}
