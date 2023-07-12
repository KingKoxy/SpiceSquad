import "dart:typed_data";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";

/// Data for creating a new recipe
class RecipeCreationData {
  /// The title of the recipe
  final String title;

  /// The duration of the recipe in minutes
  final int duration;

  /// The difficulty of the recipe
  final Difficulty difficulty;

  /// Whether the recipe is vegetarian
  final bool isVegetarian;

  /// Whether the recipe is vegan
  final bool isVegan;

  /// Whether the recipe is gluten free
  final bool isGlutenFree;

  /// Whether the recipe is halal
  final bool isHalal;

  /// Whether the recipe is kosher
  final bool isKosher;

  /// The ingredients of the recipe
  final List<Ingredient> ingredients;

  /// The instructions of the recipe
  final String instructions;

  /// The default portion amount of the recipe that is used for calculating the amount of ingredients
  final int defaultPortionAmount;

  /// The image of the recipe
  final Uint8List? image;

  /// Creates a new recipe creation data
  RecipeCreationData({
    required this.title,
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
    this.image,
  });

  static Map<String, dynamic> toMap(RecipeCreationData recipe) {
    return {
      'title': recipe.title,
      'duration': recipe.duration,
      'difficulty': recipe.difficulty.toString(),
      'isVegetarian': recipe.isVegetarian,
      'isVegan': recipe.isVegan,
      'isGlutenFree': recipe.isGlutenFree,
      'isHalal': recipe.isHalal,
      'isKosher': recipe.isKosher,
      'ingredients': recipe.ingredients.map<Map<String, dynamic>>(Ingredient.toMap).toList(),
      'instructions': recipe.instructions,
      'defaultPortionAmount': recipe.defaultPortionAmount,
      'image': recipe.image,
      'isPrivate': false,
    };
  }
}
