import "dart:typed_data";

class User {
  final String id;
  final Uint8List? profileImage;
  final String userName;

  User({required this.id, required this.userName, this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        profileImage: json["profileImage"],
        userName: json["userName"],);
  }
}
