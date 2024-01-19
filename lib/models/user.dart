import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? name;
  String? email;
  String? id;
  String? phoneNumber;

  UserModel({
    this.name,
    this.phoneNumber,
    this.id,
    this.email,
  });

  UserModel.fromFirebaseUser(User user) {
    name = user.displayName;
    id = user.uid;
    email = user.email;
    phoneNumber = user.phoneNumber;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['id'] = id;
    return data;
  }
}
