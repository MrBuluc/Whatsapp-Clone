import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/locator.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/services/api_services/message_api.dart';
import 'package:whatsapp_clone/services/api_services/time_api.dart';
import 'package:whatsapp_clone/services/firebase/firestore_service.dart';
import 'package:whatsapp_clone/services/firebase/storage_service.dart';

import '../model/user.dart';

class UserRepository {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final StorageService _storageService = locator<StorageService>();
  final MessageApi _messageApi = locator<MessageApi>();
  final TimeApi _timeApi = locator<TimeApi>();

  Stream<List<Conversation>> getConversations(String userId) =>
      _firestoreService.getConversations(userId);

  Future<User?> getUser(String id) async => await _firestoreService.getUser(id);

  Future<User?> updateUser(User updatedUser, String picturePath,
      String conversationPicturePath) async {
    String? pictureUrl, conversationPictureUrl;

    if (picturePath.isNotEmpty) {
      pictureUrl = await uploadFile(
          "Users", updatedUser.id!, "picture.png", picturePath);
    }
    if (conversationPicturePath.isNotEmpty) {
      conversationPictureUrl = await uploadFile("Users", updatedUser.id!,
          "conversationPicture.png", conversationPicturePath);
    }

    updatedUser.pictureUrl = pictureUrl;
    updatedUser.conversationsPictureUrl = conversationPictureUrl;

    bool result = await _firestoreService.updateUser(
        updatedUser.id!, updatedUser.toFirestore());
    if (result) {
      return updatedUser;
    }
    return null;
  }

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

  Future<String?> chooseMedia(ImageSource imageSource) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile == null) return null;
    return pickedFile.path;
  }

  Future<String> getCurrentTimeFromEpoch() async =>
      _timeApi.getCurrentTimeFromEpoch();
}
