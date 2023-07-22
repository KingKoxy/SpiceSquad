import "dart:async";
import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:jwt_decoder/jwt_decoder.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:spice_squad/api_endpoints.dart";
import "package:spice_squad/models/user.dart";

/// Repository for user actions
///
/// This class is used to perform user actions like fetching the current user or fetching the id token of the current user.
/// It also stores the current user id and the authentication tokens.
class UserRepository {
  static const _refreshTokenPath = "refreshToken";

  String? _userId;
  String? _idToken;

  /// Fetches the current user
  Future<User?> fetchCurrentUser() async {
    final token = await getToken();
    if (token == null) {
      return null;
    }
    final response = await http.get(
      Uri.parse(ApiEndpoints.user),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: token,
      },
    );
    if (response.statusCode == 200) {
      final user = jsonDecode(response.body);
      _userId = user["id"];
      return User.fromMap(user);
    } else {
      throw Exception(response.body);
    }
  }

  /// Gets the user id that has been obtained by the [fetchCurrentUser] method or returns null if the user is not logged in
  String? getUserId() {
    return _userId;
  }

  /// Fetches the id token of the current user or returns null if the user is not logged in or the token is expired
  FutureOr<String?> getToken() async {
    if (_idToken != null && !_isExpired(_idToken!)) {
      return _idToken;
    }
    final String? refreshToken = await _getRefreshToken();
    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse(ApiEndpoints.refreshToken),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(<String, String>{
          "refreshToken": refreshToken,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        _idToken = body["idToken"];
        return _idToken;
      } else if (response.statusCode != 401) {
        throw Exception(response.body);
      }
    }
    // Wenn der Token nicht aktualisiert werden konnte, wird er gelöscht
    await deleteTokens();
    return null;
  }

  /// Returns the refresh token of the current user by fetching it from the system storage or returns null if none is available
  Future<String?> _getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenPath);
  }

  /// Returns true if the given token is expired
  bool _isExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  /// Tries to login the user and setting the id token and refresh token
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.login),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      //Set tokens
      final Map<String, dynamic> body = jsonDecode(response.body);
      _idToken = body["idToken"];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refreshTokenPath, body["refreshToken"]);
    } else if (response.statusCode == 401) {
      throw ArgumentError("INVALID_CREDENTIALS");
    } else {
      throw Exception(response.body);
    }
  }

  /// Logs out the user and deletes the id token and refresh token
  Future<void> logout() async {
    await http.post(
      Uri.parse(ApiEndpoints.logout),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await getToken()}",
      },
    );
    await deleteTokens();
    /*if (response.statusCode != 200) {
      throw Exception(response.body);
    }*/
  }

  /// Registers a new user with the given email, password and username and logs the user in
  Future<void> register(String email, String password, String userName) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.register),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
        "userName": userName,
      }),
    );
    if (response.statusCode == 200) {
      //Set tokens
      final Map<String, dynamic> body = jsonDecode(response.body);
      _idToken = body["idToken"];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refreshTokenPath, body["refreshToken"]);
    } else if (response.statusCode == 409) {
      throw ArgumentError("EMAIL_ALREADY_IN_USE");
    } else {
      throw Exception(response.body);
    }
  }

  /// Updates the current user with the given user on the server
  Future<void> updateUser(User user) async {
    final response = await http.patch(
      Uri.parse("${ApiEndpoints.user}/${user.id}"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await getToken()}",
      },
      body: jsonEncode(user.toMap()),
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  /// Deletes the current users account from the server
  Future<void> deleteAccount() async {
    final response = await http.delete(
      Uri.parse(ApiEndpoints.user),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await getToken()}",
      },
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  /// Requests a password reset for the given email
  Future<void> resetPassword(String email) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.resetPassword),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "${await getToken()}",
      },
      body: jsonEncode(<String, String>{
        "email": email,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  /// Deletes the id token and refresh token
  Future<void> deleteTokens() async {
    _idToken = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshTokenPath);
  }
}
