import 'package:clean_bloc_forms/models/local/form_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  CollectionReference _firestoreReference;

  FirestoreService(this._firestoreReference);

  Future<void> addForm({required FormModel formModel}) async {
    await _firestoreReference.add(formModel.toMap());
  }

  Future<void> deleteForm(String id) async {
    await _firestoreReference.doc(id).delete();
  }

  Future<void> updateForm(
      {required Map<String, dynamic> formModel, required String docId}) async {
    try {
      await _firestoreReference.doc(docId).update(formModel);
    } catch (e) {
      print(e.toString());
    }
  }

  Future getForms() {
    return _firestoreReference.get().then((snapshots) {
      return snapshots.docs.map(
        (doc) {
          print(doc.data().values);
          return FormModel.fromSnapshot(doc, doc.id);
        },
      ).toList();
    });
  }
}
