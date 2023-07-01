import "dart:typed_data";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/user.dart";

class Recipe {
  final String id;
  final String title;
  final User author;
  final DateTime uploadDate;
  final int duration;
  final Difficulty difficulty;
  final Uint8List? image;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isHalal;
  final bool isKosher;
  final List<Ingredient> ingredients;
  final String instructions;
  final int defaultPortionAmount;
  final bool isFavourite;
  final bool isPrivate;

  Recipe(
      {required this.id,
      required this.title,
      required this.author,
      required this.uploadDate,
      required this.duration,
      required this.difficulty,
      required this.isVegetarian, required this.isVegan, required this.isGlutenFree, required this.isHalal, required this.isKosher, required this.ingredients, required this.instructions, required this.defaultPortionAmount, required this.isFavourite, required this.isPrivate, this.image,});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        uploadDate: json["uploadDate"],
        duration: json["duration"],
        difficulty: json["difficulty"],
        image: json["image"],
        isVegetarian: json["isVegetarian"],
        isVegan: json["isVegan"],
        isGlutenFree: json["isGlutenFree"],
        isHalal: json["isHalal"],
        isKosher: json["isKosher"],
        ingredients: json["ingredients"],
        instructions: json["instructions"],
        defaultPortionAmount: json["defaultPortionAmount"],
        isFavourite: json["isFavourite"],
        isPrivate: json["isPrivate"],);
  }
}
