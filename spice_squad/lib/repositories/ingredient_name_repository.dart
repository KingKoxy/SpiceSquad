import "dart:convert";
import "dart:io";

import "../api_endpoints.dart";
import "package:http/http.dart" as http;

/// Repository for fetching ingredient names.
///
/// This class is used to fetch ingredient names from the backend.
class IngredientNameRepository {
  /// Fetches all ingredient names
  Future<List<String>> fetchIngredientNames() async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.ingredients),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => item.toString()).toList();
    } else {
      throw Exception(response.body);
    }
  }
}
