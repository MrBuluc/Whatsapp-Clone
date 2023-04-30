import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(String parentFolderName, String folderName,
          String fileName, File file) async =>
      await (await _firebaseStorage
              .ref()
              .child(parentFolderName)
              .child(folderName)
              .child(fileName)
              .putFile(file))
          .ref
          .getDownloadURL();
}
