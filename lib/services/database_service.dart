import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_testing/models/user.dart';
import '../models/category.dart';
import 'package:flutter/material.dart';
import '../models/note.dart';

class DatabaseService {
  late CollectionReference _notesRefrence;
  late CollectionReference _categoriesRefrence;
  late CollectionReference _usersRefrence;

  final String? id;

  DatabaseService({this.id}) {
    _notesRefrence = FirebaseFirestore.instance.collection("Notes_${id!}");
    _categoriesRefrence =
        FirebaseFirestore.instance.collection("Categories_${id!}");
    _usersRefrence = FirebaseFirestore.instance.collection("Users");
  }
  Future updateUserNote({required NoteModel note}) async {
    // await updateCategoryDetails(
    //     categoryModel:
    //         note.category!.copyWith(count: note.category!.count! + 1));
    log(note.toJson().toString());
    return await _notesRefrence.doc(note.id).set({
      "note": note.note ?? "",
      "date": note.date ?? DateTime.now().toString(),
      "title": note.title ?? "No Title",
      "color": note.color ?? Colors.red.shade100.value,
      // "category_id": note.category?.id,
    });
  }

  Future addUser({required UserModel user}) async {
    log(user.toJson().toString());
    return await _usersRefrence.doc(user.id).set(user.toJson());
  }

  Future updateCategoryDetails({required CategoryModel categoryModel}) async {
    return await _categoriesRefrence.doc(categoryModel.id).set({
      "name": categoryModel.name,
      "color": categoryModel.color,
      "count": categoryModel.count,
    });
  }

  Future deleteNoteDocbyId({required String id}) async {
    await _notesRefrence.doc(id).delete();
  }

  Future deleteCategoryDocbyId({required String id}) async {
    await _categoriesRefrence.doc(id).delete();
  }

  Stream<List<NoteModel>> notes({required String search}) {
    log(search);
    return _notesRefrence.snapshots().map((event) =>
        _noteListFromSnapshot(event)
            .where((element) => _search(element, search))
            .toList());
  }

  bool _search(NoteModel element, String search) {
    if (element.title!.toLowerCase().contains(search.toLowerCase()) ||
        element.note!.toLowerCase().contains(search.toLowerCase())) {
      return true;
    } else {
      return false;
    }
  }

  List<NoteModel> _noteListFromSnapshot(QuerySnapshot snapshot) {
    List<NoteModel> notes = snapshot.docs.map((doc) {
      return NoteModel(
        note: doc.get("note"),
        date: doc.get("date"),
        title: doc.get("title"),
        color: doc.get("color"),
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

  Stream<List<CategoryModel>> get categories {
    return _categoriesRefrence
        .snapshots()
        .map((event) => _categoriesListFromSnapshot(event));
  }

  List<CategoryModel> _categoriesListFromSnapshot(QuerySnapshot snapshot) {
    List<CategoryModel> categories = snapshot.docs.map((doc) {
      return CategoryModel(
        name: doc.get("name"),
        color: doc.get("color"),
        count: doc.get("count"),
        id: doc.id,
      );
    }).toList();
    categories.sort((a, b) {
      int date1 = b.count!;
      int date2 = a.count!;
      return date1.compareTo(date2);
    });
    return categories;
  }
}
