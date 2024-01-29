import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? name;
  String? email;
  String? id;
  String? phoneNumber;
  DateTime? lastOnline;
  bool isOnline = false;
  String? image;
  String? firstName;
  String? imageUrl;
  String? lastName;

  UserModel(
      {this.name,
      this.phoneNumber,
      this.id,
      this.email,
      this.image,
      this.lastOnline,
      this.isOnline = false,
      this.firstName,
      this.imageUrl,
      this.lastName});

  UserModel.fromFirebaseUser(User user) {
    name = user.displayName;
    id = user.uid;
    email = user.email;
    phoneNumber = user.phoneNumber;
    image = user.photoURL;
  }
  UserModel.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    id = data['id'];
    email = data['email'];
    phoneNumber = data['phoneNumber'];
    firstName = data['name'];
    imageUrl = data['imageUrl'];
    lastName = data['lastName'];
    image = data['image'];
    isOnline = data['isOnline'] ?? false;
    lastOnline = data['lastOnline']?.toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name ?? "No Name";
    data['firstName'] = name ?? "No Name";
    data['lastName'] = '';
    data['phoneNumber'] = phoneNumber ?? "0987654321";
    data['email'] = email ?? "a@b.c";
    data['id'] = id ?? "-1";
    data['firstName'] = name;

    data['imageUrl'] = imageUrl;
    data['lastName'] = "";
    data['isOnline'] = isOnline;
    data['lastOnline'] = lastOnline ?? DateTime.now();
    data['image'] = image;
    data['imageUrl'] = image;
    return data;
  }
}
