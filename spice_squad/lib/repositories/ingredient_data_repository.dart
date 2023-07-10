import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:http/http.dart" as http;
import "package:spice_squad/api_endpoints.dart";

/// Repository for fetching ingredient names.
///
/// This class is used to fetch ingredient names from the backend.
class IngredientDataRepository {
  /// Fetches all ingredient names
  Future<List<String>> fetchIngredientNames() async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.ingredientNames),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map<String>((item) => item["name"]).toList();
    } else {
      throw Exception(response.body);
    }
  }

  /// Fetches all ingredient names
  Future<List<Uint8List>> fetchIngredientIcons() async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.ingredientIcons),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      // TODO: map to Map<String, Uint8List>
      return [];
    } else {
      throw Exception(response.body);
    }
  }
}
