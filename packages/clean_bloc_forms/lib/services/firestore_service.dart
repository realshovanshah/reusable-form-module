import 'package:clean_bloc_forms/models/local/form_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _firestoreReference;

  FirestoreService(this._firestoreReference);

  Future<void> addForm({required FormModel formModel}) async {
    await _firestoreReference.add(formModel.toMap());
  }
}
