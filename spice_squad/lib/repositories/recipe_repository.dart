import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:spice_squad/api_endpoints.dart";
import "package:spice_squad/exceptions/http_status_exception.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/recipe_creation_data.dart";
import "package:spice_squad/repositories/user_repository.dart";

import "../exceptions/too_many_reports_exception.dart";

/// Repository for recipe actions
///
/// This class is used to perform recipe actions like fetching all recipes of a user or creating a new recipe.
class RecipeRepository {
  final UserRepository _userRepository;

  /// Creates a new [RecipeRepository]
  ///
  /// The [userRepository] is used to get the token for the authorization header.
  RecipeRepository({required UserRepository userRepository}) : _userRepository = userRepository;

  /// Fetches all recipes the current user should be allowed to see and returns them as a list
  ///
  /// Throws [HttpStatusException] if the request fails
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
      throw HttpStatusException(response);
    }
  }

  /// Sends request to create a new recipe with the values from [recipe]
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> createRecipe(RecipeCreationData recipe) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.recipe),
      headers: {
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(recipe.toMap()),
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }

  /// Sends request to delete the recipe with the given [recipeId]
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> deleteRecipe(String recipeId) async {
    final response = await http.delete(
      Uri.parse("${ApiEndpoints.recipe}/$recipeId"),
      headers: {
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }

  /// Sends request to update the recipe with the values from [recipe] by overwriting the recipe with the same id
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> updateRecipe(Recipe recipe) async {
    final response = await http.patch(
      Uri.parse("${ApiEndpoints.recipe}/${recipe.id}"),
      headers: {
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(recipe.toMap()),
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }

  /// Sends request to set the favourite value of the recipe with the given [recipeId] to [value]
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> setFavourite(String recipeId, bool value) async {
    final response = await http.patch(
      Uri.parse("${ApiEndpoints.setFavourite}/$recipeId"),
      headers: {
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(<String, bool>{
        "isFavorite": value,
      }),
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }

  /// Sends request to report the recipe with the given [recipeId]
  ///
  /// Throws [TooManyReportsException] if the recipe has already been reported in the last 24 hours.
  ///
  /// Throws [HttpStatusException] if the request fails.
  Future<void> reportRecipe(String recipeId) async {
    final response = await http.post(
      Uri.parse("${ApiEndpoints.report}/$recipeId"),
      headers: {
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
    );
    if (response.statusCode == 200) return;
    if (response.statusCode == 429) throw TooManyReportsException(recipeId);
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }
}
