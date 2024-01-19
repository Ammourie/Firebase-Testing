import 'dart:developer';

import 'package:fb_testing/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        return user;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
