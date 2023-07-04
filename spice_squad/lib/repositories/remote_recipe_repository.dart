import "dart:math";
import "dart:typed_data";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/user.dart";
import "package:spice_squad/repositories/user_repository.dart";

/// Repository for recipe actions
///
/// This class is used to perform recipe actions like fetching all recipes of a user or creating a new recipe.
class RemoteRecipeRepository {
  final UserRepository _userRepository;

  /// Creates a new [RemoteRecipeRepository] with the given [UserRepository]
  RemoteRecipeRepository(this._userRepository);

  /// Fetches all recipes the current user should be allowed to see
  Future<List<Recipe>> fetchAllRecipesForUser() async {
    final Random random = Random();
    return Future.delayed(
      const Duration(milliseconds: 2000),
      () => List.generate(
        random.nextInt(20),
        (index) => Recipe(
          id: "recipeId",
          title: {"Lasagne", "Pizza", "Spaghetti"}.elementAt(random.nextInt(3)),
          image: random.nextBool() ? Uint8List(1) : null,
          author: User(
            id: "userId",
            userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4)),
          ),
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
          ingredients: List.generate(
            2 + random.nextInt(6),
            (index) => Ingredient(
              id: "ingredientId",
              name: "Karotten",
              iconId: "carrot",
              amount: random.nextDouble() * 200,
              unit: "g",
            ),
          ),
          instructions: "Instructions",
          defaultPortionAmount: random.nextInt(8),
        ),
      ),
    );
  }

  /// Creates a new recipe with the values from [recipe]
  Future<void> createRecipe(Recipe recipe) {
    //TODO: implement recipe creation
    throw UnimplementedError();
  }

  /// Deletes the recipe with the given [recipeId]
  Future<void> deleteRecipe(String recipeId) {
    //TODO: implement recipe deletion
    throw UnimplementedError();
  }

  /// Updates the recipe with the values from [recipe] by overwriting the recipe with the same id
  Future<void> updateRecipe(Recipe recipe) {
    //TODO: implement recipe updating
    throw UnimplementedError();
  }

  /// Sets the favourite value of the recipe with the given [recipeId] to [value]
  Future<void> setFavourite(String recipeId, bool value) {
    //TODO: implement recipe favoring
    throw UnimplementedError();
  }

  /// Reports the recipe with the given [recipeId]
  Future<void> reportRecipe(String recipeId) {
    //TODO: implement recipe reporting
    throw UnimplementedError();
  }
}
