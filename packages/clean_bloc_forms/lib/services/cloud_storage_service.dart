import 'dart:io';

import 'package:clean_bloc_forms/models/network/cloud_storage_response.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  final _storageRef;

  CloudStorageService(this._storageRef);
  Future<CloudStorageResposne?> uploadFile({
    required File file,
    required String title,
  }) async {
    final fileName = title + file.hashCode.toString();
    var fileUrl;

    try {
      final response = await _storageRef.child(fileName).putFile(file);
      fileUrl = await response.ref.getDownloadURL();
      return CloudStorageResposne(
        fileUrl,
        fileName,
      );
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }
}
