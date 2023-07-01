import "package:spice_squad/models/user.dart";

class GroupMember extends User {
  final bool isAdmin;

  GroupMember({required User user, required this.isAdmin})
      : super(
            id: user.id,
            userName: user.userName,
            profileImage: user.profileImage,);

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(user: User.fromJson(json), isAdmin: json["isAdmin"]);
  }
}
