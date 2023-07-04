import "dart:typed_data";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";

class RecipeCreationData {
  final String title;
  final int duration;
  final Difficulty difficulty;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isHalal;
  final bool isKosher;
  final List<Ingredient> ingredients;
  final String instructions;
  final int defaultPortionAmount;
  final Uint8List? image;

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
}
