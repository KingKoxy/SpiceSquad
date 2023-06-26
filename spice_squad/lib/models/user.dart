import 'dart:typed_data';

class User {
  final String id;
  final Uint8List? profileImage;
  final String userName;

  User({required this.id, this.profileImage, required this.userName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        profileImage: json["profileImage"],
        userName: json["userName"]);
  }
}
