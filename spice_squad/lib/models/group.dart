import "package:spice_squad/models/group_member.dart";
import "package:spice_squad/models/group_recipe.dart";

class Group {
  final String id;
  final String name;
  final String groupCode;
  final List<GroupMember> members;
  final List<GroupRecipe> recipes;

  Group({required this.id, required this.name, required this.groupCode, required this.members, required this.recipes});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json["id"],
      name: json["name"],
      groupCode: json["groupCode"],
      members: json["members"],
      recipes: json["recipes"],
    );
  }
}
