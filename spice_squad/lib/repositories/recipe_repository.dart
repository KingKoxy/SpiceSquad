import "dart:convert";
import "dart:io";
import "package:flutter/cupertino.dart";
import "package:http/http.dart" as http;
import "package:spice_squad/api_endpoints.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/recipe_creation_data.dart";
import "package:spice_squad/repositories/user_repository.dart";

/// Repository for recipe actions
///
/// This class is used to perform recipe actions like fetching all recipes of a user or creating a new recipe.
class RecipeRepository {
  final UserRepository _userRepository;

  /// Creates a new [RecipeRepository] with the given [UserRepository]
  RecipeRepository(this._userRepository);

  /// Fetches all recipes the current user should be allowed to see
  Future<List<Recipe>> fetchAllRecipesForUser() async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.recipe),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map<Recipe>((recipe) => Recipe.fromMap(recipe as Map<String, dynamic>)).toList();
    } else {
      throw Exception(response.body);
    }
  }

  /// Creates a new recipe with the values from [recipe]
  Future<void> createRecipe(RecipeCreationData recipe) async {
    final result = await http.post(
      Uri.parse(ApiEndpoints.recipe),
      headers: {
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(recipe, toEncodable: (value) => RecipeCreationData.toMap(value as RecipeCreationData)),
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
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
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
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
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
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(<String, bool>{
        "isFavorite": value,
      }),
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
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
    );
    if (result.statusCode != 200) {
      throw Exception(result.body);
    }
  }
}
