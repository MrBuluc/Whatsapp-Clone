import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/locator.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/services/api_services/message_api.dart';
import 'package:whatsapp_clone/services/api_services/time_api.dart';
import 'package:whatsapp_clone/services/firebase/firestore_service.dart';
import 'package:whatsapp_clone/services/firebase/storage_service.dart';
import 'package:whatsapp_clone/services/navigator_service.dart';
import 'package:whatsapp_clone/ui/const.dart';

import '../model/user.dart';

class UserRepository {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final StorageService _storageService = locator<StorageService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final MessageApi _messageApi = locator<MessageApi>();
  final TimeApi _timeApi = locator<TimeApi>();

  Stream<List<Conversation>> getConversations(String userId) =>
      _firestoreService.getConversations(userId);

  Future<User?> getUser(String id) async => await _firestoreService.getUser(id);

  Future<User?> updateUser(String id, User updatedUser) async {
    bool result =
        await _firestoreService.updateUser(id, updatedUser.toFirestore());
    if (result) {
      return updatedUser;
    }
    return null;
  }

  Future<bool> deleteUserFileField(
      String id, String fileName, String fieldName) async {
    bool result = await deleteFile(usersCollectionName, id, fileName);
    if (result) {
      return await _firestoreService.deleteUserField(id, fieldName);
    }
    return result;
  }

  Future<bool> deleteFile(
          String parentFolderName, String folderName, String fileName) async =>
      _storageService.deleteFile(parentFolderName, folderName, fileName);

  Stream<QuerySnapshot> messageStream(String conversationId) =>
      _firestoreService.messageStream(conversationId);

  Future<bool> sendMessage(
      String conversationId, Message message, String chosenMedia) async {
    if (chosenMedia.isNotEmpty) {
      message.media = await uploadMedia(conversationId, chosenMedia);
    }
    return await _messageApi.sendMessage(conversationId, message.toFirestore());
  }

  Future<String> uploadFile(String parentFolderName, String folderName,
          String fileName, String filePath) async =>
      await _storageService.uploadFile(
          parentFolderName, folderName, fileName, filePath);

  Future<String?> uploadMedia(String conversationId, String mediaPath) async =>
      uploadFile(
          "Messages",
          conversationId,
          "${await getCurrentTimeFromEpoch()}.${mediaPath.split(".").last}",
          mediaPath);

  Future<String> uploadProfilePicture(
          String userId, String profilePicturePath) async =>
      await uploadFile(usersCollectionName, userId, userProfilePictureFileName,
          profilePicturePath);

  Future<String> uploadConversationPicture(
          String userId, String conversationPicturePath) async =>
      uploadFile(usersCollectionName, userId, userConversationPictureFileName,
          conversationPicturePath);

  Future<String?> chooseMedia(ImageSource imageSource) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile == null) return null;
    return pickedFile.path;
  }

  Future<String> getCurrentTimeFromEpoch() async =>
      _timeApi.getCurrentTimeFromEpoch();

  Future navigateTo(BuildContext context, Widget page) =>
      _navigatorService.navigateTo(context, page);
}
