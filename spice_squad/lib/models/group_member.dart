import "package:spice_squad/models/user.dart";

/// Model for a group member
class GroupMember extends User {
  /// Whether or not the user is an admin of the group it is associated with
  final bool isAdmin;

  /// Creates a new [GroupMember] with the given [user] and [isAdmin]
  GroupMember({required User user, required this.isAdmin})
      : super(
          id: user.id,
          userName: user.userName,
          profileImage: user.profileImage,
        );

  /// Creates a new [GroupMember] from the given [map] object by extracting the values
  factory GroupMember.fromMap(Map<String, dynamic> map) {
    return GroupMember(user: User.fromMap(map["user"]), isAdmin: map["is_admin"]);
  }
}
