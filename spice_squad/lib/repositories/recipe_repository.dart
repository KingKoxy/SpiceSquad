import "dart:convert";
import "dart:io";
import "package:http/http.dart" as http;
import "package:spice_squad/api_endpoints.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/recipe_creation_data.dart";
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
    final response = await http.get(
      Uri.parse(ApiEndpoints.recipe),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${await _userRepository.getToken()}",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      // Don't use tear-off here because it throws an error for some reason
      return body.map((dynamic item) => Recipe.fromMap(item)).toList();
    } else {
      throw Exception(response.body);
    }
  }

  /// Creates a new recipe with the values from [recipe]
  Future<void> createRecipe(RecipeCreationData recipe) async {
    final result = await http.post(
      Uri.parse(ApiEndpoints.recipe),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${await _userRepository.getToken()}",
      },
      body: jsonEncode(recipe),
    );
    if (result.statusCode != 200) {
      throw Exception(result.body);
    }
  }

  /// Deletes the recipe with the given [recipeId]
  Future<void> deleteRecipe(String recipeId) async {
    final result = await http.delete(
      Uri.parse("${ApiEndpoints.recipe}/$recipeId"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${await _userRepository.getToken()}",
      },
    );
    if (result.statusCode != 200) {
      throw Exception(result.body);
    }
  }

  /// Updates the recipe with the values from [recipe] by overwriting the recipe with the same id
  Future<void> updateRecipe(Recipe recipe) async {
    final result = await http.patch(
      Uri.parse("${ApiEndpoints.recipe}/${recipe.id}"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${await _userRepository.getToken()}",
      },
      body: jsonEncode(recipe),
    );
    if (result.statusCode != 200) {
      throw Exception(result.body);
    }
  }

  /// Sets the favourite value of the recipe with the given [recipeId] to [value]
  Future<void> setFavourite(String recipeId, bool value) async {
    final result = await http.patch(
      Uri.parse("${ApiEndpoints.setFavourite}/$recipeId"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${await _userRepository.getToken()}",
      },
      body: {
        "favourite": value.toString(),
      },
    );
    if (result.statusCode != 200) {
      throw Exception(result.body);
    }
  }

  /// Reports the recipe with the given [recipeId]
  Future<void> reportRecipe(String recipeId) async {
    final result = await http.post(
      Uri.parse("${ApiEndpoints.report}/$recipeId"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${await _userRepository.getToken()}",
      },
    );
    if (result.statusCode != 200) {
      throw Exception(result.body);
    }
  }
}
