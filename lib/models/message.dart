import 'dart:io';
import 'dart:typed_data';

import 'package:fb_testing/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyMessage {
  UserModel? user;
  DateTime? createdAt;
  double? height;
  String? id;
  String? senderId;
  String? recId;
  String? name;
  String? text;
  int? size;
  String? status;
  String? type;
  File? image;
  String? imgUrl;
  double? width;
  bool? isSender = true;
  MyMessage({
    this.user,
    this.createdAt,
    this.height,
    this.text,
    this.name,
    this.imgUrl,
    this.id,
    this.senderId,
    this.recId,
    this.size,
    this.status,
    this.type,
    this.image,
    this.isSender,
    this.width,
  }) {
    isSender = FirebaseAuth.instance.currentUser!.uid == user!.id;
  }

  MyMessage.fromJson(Map<String, dynamic> json) {
    user = json['author'] != null ? UserModel.fromJson(json['author']) : null;
    createdAt = json['createdAt'];
    height = json['height']?.toDouble();
    id = json['id'];
    recId = json['recId'];
    senderId = json['senderId'];
    text = json['text'];
    name = json['name'];
    image = json['image'];
    imgUrl = json['imgUrl'];
    size = json['size'];
    status = json['status'];
    type = json['type'];
    width = json['width']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['author'] = user!.toJson();
    }
    data['createdAt'] = createdAt;
    data['height'] = height;
    data['text'] = text;
    data['id'] = id;
    data['imgUrl'] = imgUrl;
    data['name'] = name;
    data['size'] = size;
    data['status'] = status;
    data['type'] = type;
    // data['image'] = image;
    data['width'] = width;
    data['recId'] = recId;
    data['senderId'] = senderId;
    return data;
  }
}

class Author {
  String? firstName;
  String? id;
  String? imageUrl;
  String? lastName;

  Author({this.firstName, this.id, this.imageUrl, this.lastName});

  Author.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    id = json['id'];
    imageUrl = json['imageUrl'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['lastName'] = lastName;
    return data;
  }
}
