import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/locator.dart';
import 'package:whatsapp_clone/services/firebase/firestore_service.dart';

import '../model/user.dart';

class UserRepository {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  Stream<QuerySnapshot> conversationsStreamMembersContains(String userId) =>
      _firestoreService.conversationsStreamMembersContains(userId);

  Future<User?> getUser(String id) async => await _firestoreService.getUser(id);
}
