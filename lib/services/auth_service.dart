import 'dart:developer';
import 'dart:math' as math;

import 'package:fb_testing/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/user.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static List<int> noteColors = [
    Colors.blue.shade100.value,
    Colors.red.shade100.value,
    Colors.green.shade100.value,
    Colors.yellow.shade100.value,
    Colors.purple.shade100.value,
    Colors.orange.shade100.value,
  ];
  Stream<UserModel> get authStateChangeStream =>
      _auth.authStateChanges().map((e) => UserModel.fromFirebaseUser(e!));

  Future signInAon() async {
    try {
      UserCredential res = await _auth.signInAnonymously();

      if (res.user != null) {
        UserModel user = res.user == null
            ? UserModel()
            : UserModel.fromFirebaseUser(res.user!);
        return user;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future register({
    required String email,
    required String name,
    required String password,
    // required String phoneNumber,
  }) async {
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (res.user != null) {
        await res.user!.updateDisplayName(name);
        //  await res.user!.updatePhoneNumber(PhoneAuthCredential)
        UserModel user = res.user == null
            ? UserModel()
            : UserModel.fromFirebaseUser(res.user!);
        // CategoryModel c = CategoryModel(
        //     name: "Global", count: 0, color: Colors.grey.value, id: "global");

        // await DatabaseService(id: user.id!)
        //     .updateCategoryDetails(categoryModel: c);
        NoteModel note = NoteModel(
          title: "Lorem Ipsum",
          note:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          date: DateTime.now().toString(),
          color: noteColors[math.Random().nextInt(noteColors.length)],
        );
        await DatabaseService(id: user.id!).updateUserNote(note: note);
        user.name = name;
        await DatabaseService(id: user.id!).addUser(user: user);

        return user;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (res.user != null) {
        UserModel user = res.user == null
            ? UserModel()
            : UserModel.fromFirebaseUser(res.user!);
        await ChatService.updateUserStatus(user: user);
        return user;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future logout() async {
    try {
      await ChatService.updateUserStatus(
        user: UserModel(
          isOnline: false,
          lastOnline: DateTime.now(),
          image: null,
          imageUrl: null,
        ),
      );
      await _auth.signOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
