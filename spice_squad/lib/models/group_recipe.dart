import "package:spice_squad/models/recipe.dart";

/// Model for a group recipe
class GroupRecipe extends Recipe {
  /// Whether or not the recipe is censored in the group it is associated with
  final bool isCensored;

  /// Creates a new [GroupRecipe] with the given [recipe] and [isCensored]
  GroupRecipe({required Recipe recipe, required this.isCensored})
      : super(
          id: recipe.id,
          title: recipe.title,
          author: recipe.author,
          uploadDate: recipe.uploadDate,
          duration: recipe.duration,
          difficulty: recipe.difficulty,
          imageUrl: recipe.imageUrl,
          isVegetarian: recipe.isVegetarian,
          isVegan: recipe.isVegan,
          isGlutenFree: recipe.isGlutenFree,
          isHalal: recipe.isHalal,
          isKosher: recipe.isKosher,
          ingredients: recipe.ingredients,
          instructions: recipe.instructions,
          defaultPortionAmount: recipe.defaultPortionAmount,
          isFavourite: recipe.isFavourite,
          isPrivate: recipe.isPrivate,
        );

  /// Creates a new [GroupRecipe] from the given [map] object by extracting the values
  ///
  /// The [map] should have the following structure
  /// ```dart
  /// {
  ///   "is_censored": bool,
  ///   "recipe": {
  ///     "id": String,
  ///     "title": String,
  ///     "author": {
  ///       "id": String,
  ///       "profile_image": String,
  ///       "user_name": String
  ///     },
  ///     "upload_date": DateTime,
  ///     "duration": int,
  ///     "difficulty": String,
  ///     "image": String,
  ///     "is_vegetarian": bool,
  ///     "is_vegan": bool,
  ///     "is_gluten_free": bool,
  ///     "is_halal": bool,
  ///     "is_kosher": bool,
  ///     "ingredients": [
  ///       {
  ///         "id": String,
  ///         "name": String,
  ///         "icon": String,
  ///         "amount": double,
  ///         "unit": String
  ///       }
  ///     ],
  ///     "instructions": String,
  ///     "default_portions": int,
  ///     "isFavourite": null | bool,
  ///     "is_private": null | bool,
  ///   }
  /// }
  /// ```
  factory GroupRecipe.fromMap(Map<String, dynamic> map) {
    return GroupRecipe(
      recipe: Recipe.fromMap(map["recipe"]),
      isCensored: map["is_censored"],
    );
  }
}
