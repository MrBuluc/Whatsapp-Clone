// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_clone/locator.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/repository/user_repository.dart';

class UserModel with ChangeNotifier {
  final UserRepository _userRepository = locator<UserRepository>();
  User? user;

  Stream<QuerySnapshot> conversationsStreamMembersContains() {
    try {
      print("user.id: ${user!.id!}");
      return _userRepository.conversationsStreamMembersContains(user!.id!);
    } catch (e) {
      printError("conversationsStreamMembersContains", e);
      rethrow;
    }
  }

  Future<User?> getUser(String id) async {
    try {
      user = await _userRepository.getUser(id);
      return user;
    } catch (e) {
      printError("getUser", e);
      rethrow;
    }
  }

  // ignore: print
  printError(String methodName, Object e) {
    print("Usermodel $methodName hata: $e");
  }
}
