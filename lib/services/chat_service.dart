import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';
import '../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ChatService {
  List<UserModel> users = [];

  final CollectionReference _usersRefrence =
      FirebaseFirestore.instance.collection("Users");
  Stream<List<UserModel>> getAllUsersStram() {
    return _usersRefrence.snapshots().map(_usersListFromSnapshot);
  }

  static Stream<UserModel> getUserById(String id) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .snapshots()
        .map((doc) {
      log(doc.get('lastOnline').toDate());
      return UserModel(
        name: doc.get("name"),
        id: doc.get('id'),
        email: doc.get('email'),
        phoneNumber: doc.get('phoneNumber'),
        image: doc.get('image'),
        isOnline: doc.get('isOnline') ?? false,
        lastOnline: doc.get('lastOnline').toDate(),
      );
    });
  }

  static Future<UserModel> getUserLastOnline(String id) async {
    var doc =
        await FirebaseFirestore.instance.collection("Users").doc(id).get();
    return UserModel(
      name: doc.get("name"),
      id: doc.get('id'),
      email: doc.get('email'),
      phoneNumber: doc.get('phoneNumber'),
      image: doc.get('image'),
      isOnline: doc.get('isOnline') ?? false,
      lastOnline: doc.get('lastOnline').toDate(),
    );
  }

  List<UserModel> _usersListFromSnapshot(QuerySnapshot snapshot) {
    List<UserModel> tmp = [];
    for (var doc in snapshot.docs) {
      tmp.add(UserModel(
        name: doc.get("name"),
        id: doc.get('id'),
        email: doc.get('email'),
        // phoneNumber: doc.get('phoneNumber'),
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
            createdAt: e.get("createdAt").toDate(),
            type: e.get('type'),
            id: e.get('id'),
            imgUrl: e.get('imgUrl'),
            recId: e.get('recId'),
            senderId: e.get('senderId'),
            text: e.get('text') ?? "",
          ),
        )
        .toList();
    tmp.forEach((element) {
      log(element.text!);
    });
    return tmp;
  }

  static Future<void> addImageMessage({required MyMessage message}) async {
    FirebaseStorage _storageReference = FirebaseStorage.instance;
    Reference reference = _storageReference.ref();
    Reference folderRef = reference.child("chat/images");
    Reference imgref = folderRef.child(basename(message.image!.path));
    try {
      UploadTask uploadTask = imgref.putFile(message.image!);
      String link = await uploadTask.then((p0) async {
        return p0.ref.getDownloadURL();
      });
      // String url = await snp.ref.getDownloadURL();
      message.imgUrl = link;
      await addTextMessage(message: message);
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> updateUserStatus({required UserModel user}) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(user.toJson());
  }
}
