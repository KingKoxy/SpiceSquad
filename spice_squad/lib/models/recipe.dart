import "dart:typed_data";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/user.dart";

/// Model for a recipe
class Recipe {
  /// The id of the recipe
  final String id;

  /// The title of the recipe
  final String title;

  /// The author of the recipe
  final User author;

  /// The upload date of the recipe
  final DateTime uploadDate;

  /// The duration of the recipe
  final int duration;

  /// The difficulty of the recipe
  final Difficulty difficulty;

  /// The image of the recipe
  final Uint8List? image;

  /// Whether or not the recipe is vegetarian
  final bool isVegetarian;

  /// Whether or not the recipe is vegan
  final bool isVegan;

  /// Whether or not the recipe is gluten free
  final bool isGlutenFree;

  /// Whether or not the recipe is halal
  final bool isHalal;

  /// Whether or not the recipe is kosher
  final bool isKosher;

  /// The ingredients of the recipe
  final List<Ingredient> ingredients;

  /// The instructions of the recipe
  final String instructions;

  /// The default portion amount of the recipe the ingredient amounts are based on
  final int defaultPortionAmount;

  /// Whether or not the recipe is a favourite for the current user
  final bool isFavourite;

  /// Whether or not the recipe is private
  final bool isPrivate;

  /// Creates a new [Recipe] with the given values
  Recipe({
    required this.id,
    required this.title,
    required this.author,
    required this.uploadDate,
    required this.duration,
    required this.difficulty,
    required this.isVegetarian,
    required this.isVegan,
    required this.isGlutenFree,
    required this.isHalal,
    required this.isKosher,
    required this.ingredients,
    required this.instructions,
    required this.defaultPortionAmount,
    required this.isFavourite,
    required this.isPrivate,
    this.image,
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
