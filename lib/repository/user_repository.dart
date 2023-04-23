import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/locator.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/services/api_services/message_api.dart';
import 'package:whatsapp_clone/services/firebase/firestore_service.dart';

import '../model/user.dart';

class UserRepository {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final MessageApi _messageApi = locator<MessageApi>();

  Stream<QuerySnapshot> conversationsStreamMembersContains(String userId) =>
      _firestoreService.conversationsStreamMembersContains(userId);

  Future<User?> getUser(String id) async => await _firestoreService.getUser(id);

  Stream<QuerySnapshot> messageStream(String conversationId) =>
      _firestoreService.messageStream(conversationId);

  Future<bool> sendMessage(String conversationId, Message message) async =>
      _messageApi.sendMessage(conversationId, message.toFirestore());
}
