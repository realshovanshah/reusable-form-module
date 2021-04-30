import 'package:clean_forms/services/cloud_storage_service.dart';
import 'package:clean_forms/services/firestore_service.dart';
import 'package:clean_forms/utils/file_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt.instance;

void setUpServiceLocator() {
  serviceLocator.registerLazySingleton(() => FileSelector());
  serviceLocator.registerLazySingleton(
    () => CloudStorageService(FirebaseStorage.instance.ref()),
  );
  serviceLocator.registerLazySingleton(
    () => FirestoreService(FirebaseFirestore.instance.collection("forms")),
  );
}
