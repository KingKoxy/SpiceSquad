/// Model for a user
class User {
  /// The id of the user
  final String id;

  /// The profile image of the user as a byte array
  final String profileImageUrl;

  /// The username of the user
  final String userName;

  /// Creates a new [User] with the given [id], [userName], and [profileImageUrl]
  User({required this.id, required this.userName, required this.profileImageUrl});

  /// Creates a new [User] from the given [map] object by extracting the values
  ///
  /// The [map] should have the following structure
  /// ```dart
  /// {
  ///   "id": String,
  ///   "profile_image": null | {
  ///     "data": Uint8List
  ///   },
  ///   "user_name": String
  /// }
  /// ```
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      profileImageUrl: map["profile_image"] ?? "",
      userName: map["user_name"],
    );
  }

  /// Converts this [User] to a [Map] object by inserting the values
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "profileImage": profileImageUrl,
      "name": userName,
    };
  }
}
