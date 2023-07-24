import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:whatsapp_clone/locator.dart';
import 'package:whatsapp_clone/services/firebase/firestore_service.dart';
import 'package:whatsapp_clone/services/navigator_service.dart';
import 'package:whatsapp_clone/ui/conversation_page/conversation_page.dart';

class MessagingService {
  final NavigatorService navigatorService = locator<NavigatorService>();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FirestoreService firestoreService = locator<FirestoreService>();

  MessagingService() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      notificationClicked(message.data);
    });
  }

  Future notificationClicked(Map<String, dynamic> data) async {
    navigatorService.navigateTo(ConversationPage(
      conversation: await firestoreService.getConversation(
          data["conversationId"], data["userId"]),
      userId: data["memberId"],
    ));
  }

  Future<String?> getUserToken() async => await firebaseMessaging.getToken();
}
