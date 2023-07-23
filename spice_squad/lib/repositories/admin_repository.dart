import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:spice_squad/api_endpoints.dart";
import "package:spice_squad/repositories/user_repository.dart";

/// Repository for admin actions
///
/// This class is used to perform admin actions like making a user admin or kicking a user from a group.
class AdminRepository {
  final UserRepository _userRepository;

  /// Creates a new [AdminRepository] with the given [UserRepository]
  AdminRepository(this._userRepository);

  /// Makes the user with the given [userId] an admin of the group with the given [groupId]
  Future<void> makeAdmin(String userId, String groupId) async {
    final response = await http.patch(
      Uri.parse(ApiEndpoints.makeAdmin),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
      body: {
        "userId": userId,
        "groupId": groupId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  /// Removes the admin status of the user with the given [userId] in the group with the given [groupId]
  Future<void> removeAdminStatus(String userId, String groupId) async {
    final response = await http.patch(
      Uri.parse(ApiEndpoints.removeAdmin),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
      body: {
        "userId": userId,
        "groupId": groupId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  /// Kicks the user with the given [userId] from the group with the given [groupId]
  Future<void> kickUser(String userId, String groupId) async {
    final response = await http.patch(
      Uri.parse(ApiEndpoints.kickUser),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
      body: {
        "userId": userId,
        "groupId": groupId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  /// Bans the user with the given [userId] from the group with the given [groupId]
  Future<void> banUser(String userId, String groupId) async {
    final response = await http.patch(
      Uri.parse(ApiEndpoints.banUser),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
      body: {
        "userId": userId,
        "groupId": groupId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  /// Sets the censor status of the recipe with the given [recipeId] in the group with the given [groupId] to the given [value]
  Future<void> setCensored(String recipeId, String groupId, bool value) async {
    final response = await http.patch(
      Uri.parse("${ApiEndpoints.setCensored}/$groupId/$recipeId"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
      body: jsonEncode(<String, dynamic>{
        "recipeId": recipeId,
        "groupId": groupId,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }
}
