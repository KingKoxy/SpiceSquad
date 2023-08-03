import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:spice_squad/api_endpoints.dart";
import "package:spice_squad/exceptions/http_status_exception.dart";
import "package:spice_squad/exceptions/invalid_group_code_error.dart";
import "package:spice_squad/models/group.dart";
import "package:spice_squad/repositories/user_repository.dart";

/// Repository for group actions
///
/// This class is used to perform group actions like fetching all groups for a user or fetching a group by its id.
class GroupRepository {
  final UserRepository _userRepository;

  /// Creates a new [GroupRepository]
  ///
  /// The [userRepository] is used to get the token for the authorization header.
  GroupRepository({required UserRepository userRepository}) : _userRepository = userRepository;

  /// Fetches all groups for the current user and returns them as a list
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<List<Group>> fetchAllGroupsForUser() async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.group),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body)["groups"];
      return body.map<Group>((group) => Group.fromMap(group as Map<String, dynamic>)).toList();
    } else {
      throw HttpStatusException(response);
    }
  }

  /// Fetches the group with the given [id] and returns it
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<Group> fetchGroupById(String id) async {
    final response = await http.get(
      Uri.parse("${ApiEndpoints.group}/$id"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return Group.fromMap(body["group"] as Map<String, dynamic>);
    } else {
      throw HttpStatusException(response);
    }
  }

  /// Sends request to make the current user join the group with the given [groupCode]
  ///
  /// Throws [InvalidGroupCodeError] if the group code is invalid or [HttpStatusException] if the request fails for other reasons
  Future<void> joinGroup(String groupCode) async {
    final response = await http.patch(
      Uri.parse(ApiEndpoints.joinGroup),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
      body: jsonEncode(<String, String>{
        "groupCode": groupCode,
      }),
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 404) {
        throw InvalidGroupCodeError(groupCode: groupCode);
      }
      throw HttpStatusException(response);
    }
  }

  /// Sends request to make the current user leave the group with the given [groupId]
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> leaveGroup(String groupId) async {
    final response = await http.patch(
      Uri.parse("${ApiEndpoints.leaveGroup}/$groupId"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }

  /// Sends request to create a new group with the given [name]
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> createGroup(String name) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.group),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
      body: jsonEncode(<String, String>{
        "groupName": name,
      }),
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }

  /// Sends request to update the given [group] by overwriting the group on the server with the same id
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> updateGroup(Group group) async {
    final response = await http.patch(
      Uri.parse("${ApiEndpoints.group}/${group.id}"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
      body: jsonEncode(group),
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }

  /// Sends request to delete the group with the given [groupId]
  ///
  /// Throws [HttpStatusException] if the request fails
  Future<void> deleteGroup(String groupId) async {
    final response = await http.delete(
      Uri.parse("${ApiEndpoints.group}/$groupId"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await _userRepository.getToken()}",
      },
    );
    if (response.statusCode != 200) {
      throw HttpStatusException(response);
    }
  }
}
