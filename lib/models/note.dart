class NoteModel {
  String? note;
  String? date;
  String? title;
  String? id;
  int? color;
  // CategoryModel? category;
  NoteModel({
    this.note,
    this.date,
    this.title,
    this.color,
    // this.category,
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
    data['title'] = title;
    data['color'] = color;
    // if (category != null) {
    //   data['category'] = category!.toJson();
    // } else {
    //   data['category'] = null;
    // }
    data['id'] = id;

    return data;
  }
}
