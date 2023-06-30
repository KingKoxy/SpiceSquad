import 'dart:math';
import 'dart:typed_data';

import 'package:spice_squad/models/recipe.dart';
import 'package:spice_squad/repositories/user_repository.dart';

import '../models/difficulty.dart';
import '../models/ingredient.dart';
import '../models/user.dart';

class RemoteRecipeRepository {
  final UserRepository _userRepository;

  RemoteRecipeRepository(this._userRepository);

  Future<List<Recipe>> fetchAllRecipesForUser() async {
    final Random random = Random();
    return Future.delayed(
        const Duration(milliseconds: 2000),
        () => List.generate(
            10 + random.nextInt(20),
            (index) => Recipe(
                  id: "recipeId",
                  title: {"Lasagne", "Pizza", "Spagghetti"}.elementAt(random.nextInt(3)),
                  image: random.nextBool() ? Uint8List(1) : null,
                  author: User(
                      id: "userId", userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4))),
                  uploadDate: DateTime.now(),
                  duration: random.nextInt(120),
                  difficulty: Difficulty.values[random.nextInt(3)],
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

  Future<void> createRecipe(Recipe recipe) {
    //TODO: implement recipe creation
    throw UnimplementedError();
  }

  Future<void> deleteRecipe(String recipeId) {
    //TODO: implement recipe deletion
    throw UnimplementedError();
  }

  Future<void> updateRecipe(Recipe recipe) {
    //TODO: implement recipe updating
    throw UnimplementedError();
  }

  Future<void> setFavourite(String recipeId, bool value) {
    //TODO: implement recipe favoring
    throw UnimplementedError();
  }

  Future<void> reportRecipe(String recipeId) {
    //TODO: implement recipe reporting
    throw UnimplementedError();
  }
}
