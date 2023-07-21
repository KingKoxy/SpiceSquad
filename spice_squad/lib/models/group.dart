import "package:spice_squad/models/group_member.dart";
import "package:spice_squad/models/group_recipe.dart";

/// Model for a group
class Group {
  /// The id of the group
  final String id;

  /// The name of the group
  final String name;

  /// The group code of the group
  final String groupCode;

  /// The members of the group
  final List<GroupMember> members;

  /// The recipes of the group
  final List<GroupRecipe> recipes;

  /// Creates a new [Group] with the given [id], [name], [groupCode], [members], and [recipes]
  Group({required this.id, required this.name, required this.groupCode, required this.members, required this.recipes});

  /// Creates a new [Group] from the given [map] object by extracting the values
  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map["id"],
      name: map["name"],
      groupCode: map["group_code"],
      members: map["members"].map<GroupMember>((user) => GroupMember.fromMap(user as Map<String, dynamic>)).toList(),
      recipes: map["recipes"].map<GroupRecipe>((recipe) => GroupRecipe.fromMap(recipe as Map<String, dynamic>)).toList(),
    );
  }
}
