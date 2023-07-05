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
      author: map["author"],
      uploadDate: map["uploadDate"],
      duration: map["duration"],
      difficulty: map["difficulty"],
      image: map["image"],
      isVegetarian: map["isVegetarian"],
      isVegan: map["isVegan"],
      isGlutenFree: map["isGlutenFree"],
      isHalal: map["isHalal"],
      isKosher: map["isKosher"],
      ingredients: map["ingredients"],
      instructions: map["instructions"],
      defaultPortionAmount: map["defaultPortionAmount"],
      isFavourite: map["isFavourite"],
      isPrivate: map["isPrivate"],
    );
  }
}
