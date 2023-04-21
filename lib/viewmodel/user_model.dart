// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_clone/locator.dart';
import 'package:whatsapp_clone/repository/user_repository.dart';

class UserModel with ChangeNotifier {
  final UserRepository _userRepository = locator<UserRepository>();

  Stream<QuerySnapshot> chatsStream() {
    try {
      return _userRepository.chatsStream();
    } catch (e) {
      printError("chatsStream", e);
      rethrow;
    }
  }

  // ignore: print
  printError(String methodName, Object e) {
    print("Usermodel $methodName hata: $e");
  }
}
