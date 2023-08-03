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
      profileImage: map["profile_image"] != null ? Uint8List.fromList(map["profile_image"]["data"].cast<int>()) : null,
      userName: map["user_name"],
    );
  }

  /// Converts this [User] to a [Map] object by inserting the values
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "profileImage": profileImage?.toList(),
      "name": userName,
    };
  }
}
