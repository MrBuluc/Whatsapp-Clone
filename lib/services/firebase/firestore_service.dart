import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/user.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _conversationsRef, _usersRef;

  FirestoreService() {
    _conversationsRef = _firestore
        .collection("Conversations")
        .withConverter<Conversation>(
            fromFirestore: (snapshot, _) =>
                Conversation.fromFirestore(snapshot.data()!),
            toFirestore: (chat, _) => {});
    _usersRef = _firestore.collection("Users").withConverter<User>(
        fromFirestore: ((snapshot, _) => User.fromFirestore(snapshot.data()!)),
        toFirestore: (user, _) => user.toFirestore());
  }

  Stream<QuerySnapshot> conversationsStreamMembersContains(String userId) =>
      _conversationsRef.where("members", arrayContains: userId).snapshots();

  Future<User?> getUser(String id) async =>
      (await _usersRef.doc(id).get().then((snapshot) => snapshot.data()))
          as User;
}
