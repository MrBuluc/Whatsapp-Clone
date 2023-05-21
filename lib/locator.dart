import 'package:get_it/get_it.dart';
import 'package:whatsapp_clone/repository/user_repository.dart';
import 'package:whatsapp_clone/services/api_services/conversation_api.dart';
import 'package:whatsapp_clone/services/api_services/message_api.dart';
import 'package:whatsapp_clone/services/api_services/time_api.dart';
import 'package:whatsapp_clone/services/api_services/user_api.dart';
import 'package:whatsapp_clone/services/firebase/firestore_service.dart';
import 'package:whatsapp_clone/services/firebase/storage_service.dart';
import 'package:whatsapp_clone/services/navigator_service.dart';

GetIt locator = GetIt.I;

setupLocator() {
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => MessageApi());
  locator.registerLazySingleton(() => TimeApi());
  locator.registerLazySingleton(() => UserApi());
  locator.registerLazySingleton(() => ConversationApi());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => NavigatorService());
}
