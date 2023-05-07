import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final Reference _firebaseStorageRef = FirebaseStorage.instance.ref();

  Future<String> uploadFile(String parentFolderName, String folderName,
          String fileName, String filePath) async =>
      await (await _firebaseStorageRef
              .child(parentFolderName)
              .child(folderName)
              .child(fileName)
              .putFile(File(filePath)))
          .ref
          .getDownloadURL();

  Future<bool> deleteFile(
      String parentFolderName, String folderName, String fileName) async {
    _firebaseStorageRef
        .child(parentFolderName)
        .child(folderName)
        .child(fileName)
        .delete();
    return true;
  }
}
