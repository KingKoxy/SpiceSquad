import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:spice_squad/api_endpoints.dart";
import "package:spice_squad/exceptions/http_status_exception.dart";
import "package:spice_squad/repositories/user_repository.dart";

/// Repository for admin actions
///
/// This class is used to perform admin actions like making a user admin or kicking a user from a group.
class AdminRepository {
  final UserRepository _userRepository;

  /// Creates a new [AdminRepository]
  ///
  /// The [userRepository] is used to get the token for the authorization header.
  AdminRepository({required UserRepository userRepository}) : _userRepository = userRepository;

  /// Sends request to make the user with the given [userId] an admin of the group with the given [groupId]
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> makeAdmin(String userId, String groupId) async {
    final response = await http.patch(
      Uri.parse("${ApiEndpoints.makeAdmin}/$groupId/$userId"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }

  /// Sends request to remove the admin status of the user with the given [userId] in the group with the given [groupId]
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> removeAdminStatus(String userId, String groupId) async {
    final response = await http.patch(
      Uri.parse("${ApiEndpoints.removeAdmin}/$groupId/$userId"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }

  /// Sends request to kick the user with the given [userId] from the group with the given [groupId]
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> kickUser(String userId, String groupId) async {
    final response = await http.patch(
      Uri.parse("${ApiEndpoints.kickUser}/$groupId/$userId"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }

  /// Sends request to ban the user with the given [userId] from the group with the given [groupId]
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> banUser(String userId, String groupId) async {
    final response = await http.patch(
      Uri.parse("${ApiEndpoints.banUser}/$groupId/$userId"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }

  /// Sends request to set the censor status of the recipe with the given [recipeId] in the group with the given [groupId] to the given [value]
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> setCensored(String recipeId, String groupId, bool value) async {
    final response = await http.patch(
      Uri.parse("${ApiEndpoints.setCensored}/$groupId/$recipeId"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
      body: jsonEncode({"censored": value}),
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }
}
