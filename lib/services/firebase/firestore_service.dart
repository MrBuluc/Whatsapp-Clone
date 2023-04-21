import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/model/chat.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _chatsRef;

  FirestoreService() {
    _chatsRef = _firestore.collection("Chats").withConverter<Chat>(
        fromFirestore: (snapshot, _) => Chat.fromFirestore(snapshot.data()!),
        toFirestore: (chat, _) => {});
  }

  Stream<QuerySnapshot> chatsStream() => _chatsRef.snapshots();
}
