import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:http/http.dart" as http;
import "package:spice_squad/api_endpoints.dart";
import "package:spice_squad/exceptions/http_status_exception.dart";
import "package:spice_squad/repositories/user_repository.dart";

/// Repository for admin actions
///
/// This class is used to perform admin actions like making a user admin or kicking a user from a group.
class ImageRepository {
  final UserRepository _userRepository;

  /// Creates a new [ImageRepository]
  ///
  /// The [userRepository] is used to get the token for the authorization header.
  ImageRepository({required UserRepository userRepository}) : _userRepository = userRepository;

  /// Sends request to upload the given [image] and returns the url of the uploaded image
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<String> uploadImage(Uint8List? image) async {
    if (image == null) return "";
    final response = await http.post(
      Uri.parse(ApiEndpoints.image),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
      body: jsonEncode({"image": image}),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body)["id"];
    }
    throw HttpStatusException(response);
  }

  /// Sends request to update the image with the given [imageUrl] to the given [image]
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<String> updateImage(String imageUrl, Uint8List? image) async {
    if (image == null) return "";
    final response = await http.patch(
      Uri.parse(imageUrl),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
      body: jsonEncode({"image": image}),
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
    return imageUrl;
  }
}
