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
  ///
  /// The [map] should have the following structure
  /// ```dart
  /// {
  ///   "id": String,
  ///   "name": String,
  ///   "group_code": String,
  ///   "members": [
  ///     {
  ///       "id": String,
  ///       "profile_image": null | {
  ///         "data": Uint8List
  ///       },
  ///       "user_name": String,
  ///       "is_admin": bool
  ///     }
  ///   ],
  ///   "recipes": [
  ///     {
  ///       "is_censored": bool,
  ///       "recipe": {
  ///         "id": String,
  ///         "title": String,
  ///         "author": {
  ///           "id": String,
  ///           "profile_image": null | {
  ///               "data": Uint8List
  ///           },
  ///           "user_name": String
  ///         },
  ///         "upload_date": DateTime,
  ///         "duration": int,
  ///         "difficulty": String,
  ///         "image": null | {
  ///           "data": Uint8List
  ///         },
  ///         "is_vegetarian": bool,
  ///         "is_vegan": bool,
  ///         "is_gluten_free": bool,
  ///         "is_halal": bool,
  ///         "is_kosher": bool,
  ///         "ingredients": [
  ///           {
  ///             "id": String,
  ///             "name": String,
  ///             "icon": {
  ///               "data": Uint8List
  ///             },
  ///             "amount": double,
  ///             "unit": String
  ///           }
  ///         ],
  ///         "instructions": String,
  ///         "default_portions": int,
  ///         "isFavourite": null | bool,
  ///         "is_private": null | bool,
  ///       }
  ///     }
  ///   ]
  /// }
  /// ```
  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map["id"],
      name: map["name"],
      groupCode: map["group_code"],
      members: map["members"].map<GroupMember>((user) => GroupMember.fromMap(user as Map<String, dynamic>)).toList(),
      recipes:
          map["recipes"].map<GroupRecipe>((recipe) => GroupRecipe.fromMap(recipe as Map<String, dynamic>)).toList(),
    );
  }
}
