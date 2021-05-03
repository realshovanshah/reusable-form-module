import 'dart:io';
import 'dart:typed_data';

import 'package:clean_bloc_forms/models/network/cloud_storage_response.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  Reference _storageRef;

  CloudStorageService(this._storageRef);
  Future<CloudStorageResposne?> uploadFile({
    required Uint8List fileBytes,
    required String title,
  }) async {
    final fileName = title + '-' + fileBytes.hashCode.toString();
    var fileUrl;

    try {
      final response = await _storageRef.child(fileName).putData(fileBytes);
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

  Future deleteForm(String fileName) async {
    await _storageRef.child(fileName).delete();
  }
}
