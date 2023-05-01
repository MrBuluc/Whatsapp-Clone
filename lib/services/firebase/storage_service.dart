import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(String parentFolderName, String folderName,
          String fileName, String filePath) async =>
      await (await _firebaseStorage
              .ref()
              .child(parentFolderName)
              .child(folderName)
              .child(fileName)
              .putFile(File(filePath)))
          .ref
          .getDownloadURL();
}
