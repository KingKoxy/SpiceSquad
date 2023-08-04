import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "package:spice_squad/api_endpoints.dart";
import "package:spice_squad/exceptions/http_status_exception.dart";

/// Repository for fetching ingredient names and icons.
///
/// This class is used to fetch ingredient names and icons from the backend and caching them.
class IngredientDataRepository {
  /// Fetches all ingredient names and returns them as a list
  ///
  /// If the ingredient names were fetched in the last two days, return them from the shared preferences
  /// Otherwise fetch them from the backend and save them in the shared preferences
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<List<String>> fetchIngredientNames() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("ingredientNames") &&
        sharedPreferences.containsKey("ingredientNamesLastUpdate") &&
        DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(sharedPreferences.getInt("ingredientNamesLastUpdate")!))
                .inDays <
            2) {
      final List<dynamic> body = jsonDecode(sharedPreferences.getString("ingredientNames")!);
      return body.map<String>((item) => item["name"]).toList();
    }
    final response = await http.get(
      Uri.parse(ApiEndpoints.ingredientNames),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      sharedPreferences.setString("ingredientNames", response.body);
      sharedPreferences.setInt("ingredientNamesLastUpdate", DateTime.now().millisecondsSinceEpoch);
      final List<dynamic> body = jsonDecode(response.body);
      return body.map<String>((item) => item["name"]).toList();
    } else {
      throw HttpStatusException(response);
    }
  }

  /// Fetches all ingredient names and returns them as a list
  ///
  /// If the ingredient icons were fetched in the last two days, return them from the shared preferences
  /// Otherwise fetch them from the backend and save them in the shared preferences
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<List<String>> fetchIngredientIcons() async {
    // If the ingredient icons were fetched in the last two days, return them from the shared preferences
    final sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("ingredientIcons") &&
        sharedPreferences.containsKey("ingredientIconsLastUpdate") &&
        DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(sharedPreferences.getInt("ingredientIconsLastUpdate")!))
                .inDays <
            2) {
      final List<dynamic> body = jsonDecode(sharedPreferences.getString("ingredientIcons")!);
      return body.map((e) => e["icon"] as String).toList();
    }
    // Otherwise fetch them from the backend
    final response = await http.get(
      Uri.parse(ApiEndpoints.ingredientIcons),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      sharedPreferences.setString("ingredientIcons", response.body);
      sharedPreferences.setInt("ingredientIconsLastUpdate", DateTime.now().millisecondsSinceEpoch);
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => e["icon"] as String).toList();
    } else {
      throw HttpStatusException(response);
    }
  }
}
