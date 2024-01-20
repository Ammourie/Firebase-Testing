import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class DatabaseService {
  late CollectionReference _notesRefrence;

  final String? id;

  DatabaseService({this.id}) {
    _notesRefrence = FirebaseFirestore.instance.collection(id!);
  }
  Future updateUserData({
    required String note,
    required String date,
  }) async {
    return await _notesRefrence.doc().set({
      "note": note,
      "date": date,
    });
  }

  Stream<List<NoteModel>> get notes {
    return _notesRefrence
        .snapshots()
        .map((event) => _noteListFromSnapshot(event));
  }

  List<NoteModel> _noteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return NoteModel(
        note: doc.get("note"),
        date: doc.get("date"),
      );
    }).toList();
  }
}
