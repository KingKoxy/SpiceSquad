import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "package:spice_squad/api_endpoints.dart";
import "package:spice_squad/exceptions/http_status_exception.dart";

/// Repository for fetching ingredient names.
///
/// This class is used to fetch ingredient names from the backend.
class IngredientDataRepository {
  /// Fetches all ingredient names
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

  /// Fetches all ingredient icons
  Future<List<Uint8List>> fetchIngredientIcons() async {
    // If the ingredient icons were fetched in the last two days, return them from the shared preferences
    final sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("ingredientIcons") &&
        sharedPreferences.containsKey("ingredientIconsLastUpdate") &&
        DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(sharedPreferences.getInt("ingredientIconsLastUpdate")!))
                .inDays <
            2) {
      final List<dynamic> body = jsonDecode(sharedPreferences.getString("ingredientIcons")!);
      return body.map<Uint8List>((e) => Uint8List.fromList(e["icon"]["data"].cast<int>())).toList();
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
      return body.map<Uint8List>((e) => Uint8List.fromList(e["icon"]["data"].cast<int>())).toList();
    } else {
      throw HttpStatusException(response);
    }
  }
}
