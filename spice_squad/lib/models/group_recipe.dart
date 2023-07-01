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
          image: recipe.image,
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
  factory GroupRecipe.fromMap(Map<String, dynamic> map) {
    return GroupRecipe(
      recipe: Recipe.fromMap(map),
      isCensored: map["isCensored"],
    );
  }
}
