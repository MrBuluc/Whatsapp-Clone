import 'package:get_it/get_it.dart';
import 'package:whatsapp_clone/repository/user_repository.dart';
import 'package:whatsapp_clone/services/api_services/message_api.dart';
import 'package:whatsapp_clone/services/firebase/firestore_service.dart';

GetIt locator = GetIt.I;

setupLocator() {
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => MessageApi());
}
