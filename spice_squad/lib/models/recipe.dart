import "dart:typed_data";

import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/recipe_creation_data.dart";
import "package:spice_squad/models/user.dart";

/// Model for a recipe
class Recipe extends RecipeCreationData {
  /// The id of the recipe
  final String id;

  /// The author of the recipe
  final User author;

  /// The upload date of the recipe
  final DateTime uploadDate;

  /// Whether or not the recipe is a favourite for the current user
  final bool isFavourite;

  /// Whether or not the recipe is private
  final bool isPrivate;

  /// Creates a new [Recipe] with the given values
  Recipe({
    required this.id,
    required super.title,
    required this.author,
    required this.uploadDate,
    required super.duration,
    required super.difficulty,
    required super.isVegetarian,
    required super.isVegan,
    required super.isGlutenFree,
    required super.isHalal,
    required super.isKosher,
    required super.ingredients,
    required super.instructions,
    required super.defaultPortionAmount,
    required this.isFavourite,
    required this.isPrivate,
    super.image,
  });

  /// Creates a new [Recipe] from the given [map] object by extracting the values
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map["id"],
      title: map["title"],
      author: User.fromMap(map["author"]),
      uploadDate: DateTime.parse(map["upload_date"]),
      duration: map["duration"],
      difficulty: Difficulty.fromString(map["difficulty"]),
      image: map["image"] != null ? Uint8List.fromList(map["image"]["data"].cast<int>()) : null,
      isVegetarian: map["is_vegetarian"],
      isVegan: map["is_vegan"],
      isGlutenFree: map["is_gluten_free"],
      isHalal: map["is_halal"],
      isKosher: map["is_kosher"],
      ingredients: map["ingredients"].map<Ingredient>((v) => Ingredient.fromMap(v as Map<String, dynamic>)).toList(),
      instructions: map["instructions"],
      defaultPortionAmount: map["default_portions"],
      isFavourite: map["isFavourite"],
      isPrivate: map["is_private"],
    );
  }
}
