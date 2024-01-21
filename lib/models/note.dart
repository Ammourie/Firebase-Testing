class NoteModel {
  String? note;
  String? date;
  String? id;

  NoteModel({
    this.note,
    this.date,
    this.id,
  });

  // NoteModel.Fromx(QuerySnapshot snapshot) {
  //   // note = user.displaynote;
  //   // id = user.uid;
  //   // date = user.date;
  //   // phoneNumber = user.phoneNumber;
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note'] = note;
    data['date'] = date;
    data['id'] = id;

    return data;
  }
}
