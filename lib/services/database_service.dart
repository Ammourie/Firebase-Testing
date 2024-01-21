import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class DatabaseService {
  late CollectionReference _notesRefrence;

  final String? id;

  DatabaseService({this.id}) {
    _notesRefrence = FirebaseFirestore.instance.collection(id!);
  }
  Future updateUserData(
      {required String note, required String date, String? id}) async {
    return await _notesRefrence.doc(id).set({
      "note": note,
      "date": date,
    });
  }

  Future deleteDocbyId({required String id}) async {
    await _notesRefrence.doc(id).delete();
  }

  Stream<List<NoteModel>> get notes {
    return _notesRefrence
        .snapshots()
        .map((event) => _noteListFromSnapshot(event));
  }

  List<NoteModel> _noteListFromSnapshot(QuerySnapshot snapshot) {
    List<NoteModel> notes = snapshot.docs.map((doc) {
      return NoteModel(
        note: doc.get("note"),
        date: doc.get("date"),
        id: doc.id,
      );
    }).toList();
    notes.sort((a, b) {
      String date1 = b.date!;
      String date2 = a.date!;
      return date1.compareTo(date2);
    });
    return notes;
  }
}
