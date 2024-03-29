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
    super.imageUrl = "",
  });

  /// Creates a new [Recipe] from the given [map] object by extracting the values
  ///
  /// The [map] should have the following structure
  /// ```dart
  /// {
  ///   "id": String,
  ///   "title": String,
  ///   "author": {
  ///     "id": String,
  ///     "profile_image": String
  ///     "user_name": String
  ///   },
  ///   "upload_date": DateTime,
  ///   "duration": int,
  ///   "difficulty": String,
  ///   "image": String,
  ///   "is_vegetarian": bool,
  ///   "is_vegan": bool,
  ///   "is_gluten_free": bool,
  ///   "is_halal": bool,
  ///   "is_kosher": bool,
  ///   "ingredients": [
  ///     {
  ///       "id": String,
  ///       "name": String,
  ///       "icon": String,
  ///       "amount": double,
  ///       "unit": String
  ///     }
  ///   ],
  ///   "instructions": String,
  ///   "default_portions": int,
  ///   "isFavourite": null | bool,
  ///   "is_private": null | bool,
  /// }
  ///```
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map["id"],
      title: map["title"],
      author: User.fromMap(map["author"]),
      uploadDate: DateTime.parse(map["upload_date"]),
      duration: map["duration"],
      difficulty: Difficulty.fromString(map["difficulty"]),
      imageUrl: map["image"] ?? "",
      isVegetarian: map["is_vegetarian"],
      isVegan: map["is_vegan"],
      isGlutenFree: map["is_gluten_free"],
      isHalal: map["is_halal"],
      isKosher: map["is_kosher"],
      ingredients: map["ingredients"].map<Ingredient>((v) => Ingredient.fromMap(v as Map<String, dynamic>)).toList(),
      instructions: map["instructions"],
      defaultPortionAmount: map["default_portions"],
      isFavourite: map["isFavourite"] ?? false,
      isPrivate: map["is_private"] ?? false,
    );
  }

  /// Creates a new [Recipe] by copying this one and replacing the given values
  Recipe copyWith({
    String? title,
    int? duration,
    Difficulty? difficulty,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    bool? isHalal,
    bool? isKosher,
    List<Ingredient>? ingredients,
    String? instructions,
    int? defaultPortionAmount,
    bool? isFavourite,
    bool? isPrivate,
    String? imageUrl,
  }) {
    return Recipe(
      id: id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isHalal: isHalal ?? this.isHalal,
      isKosher: isKosher ?? this.isKosher,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      defaultPortionAmount: defaultPortionAmount ?? this.defaultPortionAmount,
      isFavourite: isFavourite ?? this.isFavourite,
      isPrivate: isPrivate ?? this.isPrivate,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author,
      uploadDate: uploadDate,
    );
  }

  /// Converts this [Recipe] to a [Map] object by inserting the values
  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      "id": id,
      "author": author.toMap(),
      "uploadDate": uploadDate.toIso8601String(),
      "isFavourite": isFavourite,
      "isPrivate": isPrivate,
    };
  }
}
