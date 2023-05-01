import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/ui/const.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _conversationsRef, _usersRef, _messageRef;

  FirestoreService() {
    _conversationsRef = _firestore
        .collection("Conversations")
        .withConverter<Conversation>(
            fromFirestore: ((snapshot, _) =>
                Conversation.fromFirestore(snapshot.data()!)),
            toFirestore: (conversation, _) => {});
    _usersRef = _firestore.collection("Users").withConverter<User>(
        fromFirestore: ((snapshot, _) => User.fromFirestore(snapshot.data()!)),
        toFirestore: (user, _) => user.toFirestore());
  }

  Stream<List<Conversation>> getConversations(String userId) =>
      _conversationsRef
          .where("members", arrayContains: userId)
          .snapshots()
          .asyncMap((QuerySnapshot conversationSnapshot) async {
        List<Conversation> conversations = [];
        for (QueryDocumentSnapshot queryDocumentSnapshot
            in conversationSnapshot.docs) {
          Conversation conversation =
              queryDocumentSnapshot.data()! as Conversation;
          User otherUser = (await getUser(
              conversation.members!.firstWhere((member) => member != userId)))!;
          conversation.name = otherUser.username;
          conversation.profileImage = otherUser.pictureUrl;
          conversation.wallpaperUrl = otherUser.conversationsPictureUrl;
          conversations.add(conversation);
        }
        return conversations;
      });

  Future<User?> getUser(String id) async =>
      (await _usersRef.doc(id).get().then((snapshot) => snapshot.data()))
          as User;

  Future<bool> updateUser(String id, Map<String, dynamic> userMap) async {
    try {
      await _usersRef.doc(id).update(userMap);
      return true;
    } catch (e) {
      classPrintError("updateUser", e);
      rethrow;
    }
  }

  Stream<QuerySnapshot> messageStream(String conversationId) {
    _messageRef = _conversationsRef
        .doc(conversationId)
        .collection("Messages")
        .withConverter<Message>(
            fromFirestore: ((snapshot, _) =>
                Message.fromFirestore(snapshot.data()!)),
            toFirestore: (message, _) => message.toFirestore());
    return _messageRef.orderBy("time").snapshots();
  }

  classPrintError(String methodName, Object e) {
    printError("Firestore", methodName, e);
  }
}
