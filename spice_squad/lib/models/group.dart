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
    //TODO: Use list directly instead of this weird shit when raphael gets his code to work
    final List<GroupMember> members = [];
    for (int i = 0; i < map["members"].length; i++) {
      members.add(GroupMember.fromMap({...map["members"][i][i.toString()], "is_admin": map["members"][i]["is_admin"]}));
    }
    return Group(
      id: map["id"],
      name: map["name"],
      groupCode: map["group_code"],
      //members: map["members"].map<GroupMember>((user) => GroupMember.fromMap(user as Map<String, dynamic>)).toList(),
      members: members,
      recipes:
          map["recipes"].map<GroupRecipe>((recipe) => GroupRecipe.fromMap(recipe as Map<String, dynamic>)).toList(),
    );
  }
}
