import "package:spice_squad/models/recipe.dart";

class GroupRecipe extends Recipe {
  final bool isCensored;

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
            isPrivate: recipe.isPrivate,);

  factory GroupRecipe.fromJson(Map<String, dynamic> json) {
    return GroupRecipe(
        recipe: Recipe.fromJson(json), isCensored: json["isCensored"],);
  }
}
