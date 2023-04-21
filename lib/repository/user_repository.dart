import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/locator.dart';
import 'package:whatsapp_clone/services/firebase/firestore_service.dart';

class UserRepository {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  Stream<QuerySnapshot> chatsStream() => _firestoreService.chatsStream();
}
