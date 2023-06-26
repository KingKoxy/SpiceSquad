import 'dart:math';

import 'package:spice_squad/models/recipe.dart';

import '../models/difficulty.dart';
import '../models/ingredient.dart';
import '../models/user.dart';

class RemoteRecipeRepository {
  Future<List<Recipe>> fetchAllRecipesForUser() async {
    final Random random = Random();
    return Future.delayed(
        const Duration(milliseconds: 2000),
        () => List.generate(
            40,
            (index) => Recipe(
                  id: "recipeId",
                  title: "Lasagne",
                  author: User(id: "userId", userName: "Konrad"),
                  uploadDate: DateTime.now(),
                  duration: random.nextInt(120),
                  difficulty: Difficulty.medium,
                  isVegetarian: random.nextBool(),
                  isVegan: random.nextBool(),
                  isGlutenFree: random.nextBool(),
                  isPrivate: random.nextBool(),
                  isFavourite: random.nextBool(),
                  isKosher: random.nextBool(),
                  isHalal: random.nextBool(),
                  ingredients: [
                    Ingredient(
                        id: "ingredientId",
                        name: "Mehl",
                        iconId: "iconId",
                        amount: random.nextDouble() * 200,
                        unit: "g")
                  ],
                  instructions: 'Instructions',
                  defaultPortionAmount: random.nextInt(8),
                )));
  }
}
