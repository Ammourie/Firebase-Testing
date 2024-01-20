import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String? note;
  String? date;

  NoteModel({
    this.note,
    this.date,
  });

  NoteModel.Fromx(QuerySnapshot snapshot) {
    // note = user.displaynote;
    // id = user.uid;
    // date = user.date;
    // phoneNumber = user.phoneNumber;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note'] = note;
    data['date'] = date;

    return data;
  }
}
