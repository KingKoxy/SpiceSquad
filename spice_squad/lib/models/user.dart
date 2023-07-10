import "dart:typed_data";

/// Model for a user
class User {
  /// The id of the user
  final String id;

  /// The profile image of the user as a byte array
  final Uint8List? profileImage;

  /// The username of the user
  final String userName;

  /// Creates a new [User] with the given [id], [userName], and [profileImage]
  User({required this.id, required this.userName, this.profileImage});

  /// Creates a new [User] from the given [map] object by extracting the values
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      profileImage: map["profile_image"],
      userName: map["user_name"],
    );
  }
}
