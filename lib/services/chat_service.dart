import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_testing/models/message.dart';
import 'package:fb_testing/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  List<UserModel> users = [];
  final CollectionReference _usersRefrence =
      FirebaseFirestore.instance.collection("Users");
  Stream<List<UserModel>> getAllUsersStram() {
    return _usersRefrence.snapshots().map(_usersListFromSnapshot);
  }

  List<UserModel> _usersListFromSnapshot(QuerySnapshot snapshot) {
    List<UserModel> tmp = [];
    for (var doc in snapshot.docs) {
      tmp.add(UserModel(
        name: doc.get("name"),
        id: doc.get('id'),
        email: doc.get('email'),
        phoneNumber: doc.get('phoneNumber'),
        image: doc.get('image'),
        isOnline: doc.get('isOnline') ?? false,
        lastOnline: doc.get('lastOnline').toDate(),
      ));
    }
    return tmp;
  }

  static Future<void> addTextMessage({required MyMessage message}) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(message.senderId)
        .collection("chat")
        .doc(message.recId)
        .collection('messages')
        .add(message.toJson());
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(message.recId)
        .collection("chat")
        .doc(message.senderId)
        .collection('messages')
        .add(message.toJson());
  }

  Stream<List<MyMessage>> getMessages({required String recid}) {
    return _usersRefrence
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chat")
        .doc(recid)
        .collection("messages")
        .snapshots()
        .map(_messageListFromSnapshot);
  }

  List<MyMessage> _messageListFromSnapshot(QuerySnapshot snapshot) {
    List<MyMessage> tmp = snapshot.docs
        .map(
          (e) => MyMessage(
            user: UserModel.fromJson(e.get("author")),
            createdAt: e.get("createdAt"),
            type: e.get('type'),
            id: e.get('id'),
            recId: e.get('recId'),
            senderId: e.get('senderId'),
            text: e.get('text'),
          ),
        )
        .toList();
    tmp.forEach((element) {
      log(element.text!);
    });
    return tmp;
  }
}