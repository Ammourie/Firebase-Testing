import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? name;
  String? email;
  String? id;
  String? phoneNumber;
  DateTime? lastOnline;
  bool isOnline = false;
  String? firstName;
  String? image = url;
  String? imageUrl = url;
  String? lastName;
  static const String url =
      "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/14f41ed6-c761-401b-b6b3-5f3721aaaac2/dfpo2gx-1d20b646-6f64-468c-9438-174a4a644e21.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzE0ZjQxZWQ2LWM3NjEtNDAxYi1iNmIzLTVmMzcyMWFhYWFjMlwvZGZwbzJneC0xZDIwYjY0Ni02ZjY0LTQ2OGMtOTQzOC0xNzRhNGE2NDRlMjEuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.61lhbWin9Fd4MHEGxQxYWWeHKwWik-0kOLHaRvU3i7s";
  UserModel(
      {this.name,
      this.phoneNumber,
      this.id,
      this.email,
      this.lastOnline,
      this.isOnline = false,
      this.firstName,
      this.image = url,
      this.imageUrl = url,
      this.lastName});

  UserModel.fromFirebaseUser(User user) {
    name = user.displayName;
    id = user.uid;
    email = user.email;
    phoneNumber = user.phoneNumber;
    // image = user.photoURL ?? url;

    firstName = user.displayName;
    // imageUrl = user.photoURL ?? url;
    lastName = "";

    isOnline = true;
    lastOnline = DateTime.now();
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
    if (name != null) data['name'] = name;
    if (name != null) data['firstName'] = name;
    data['lastName'] = '';
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (email != null) data['email'] = email;
    if (id != null) data['id'] = id;
    if (name != null) data['firstName'] = name;

    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (lastName != null) data['lastName'] = "";
    data['isOnline'] = isOnline;
    if (lastOnline != null) data['lastOnline'] = lastOnline ?? DateTime.now();
    if (image != null) data['image'] = image;
    if (imageUrl != null) data['imageUrl'] = image;
    return data;
  }
}
