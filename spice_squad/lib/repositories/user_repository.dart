import "dart:async";
import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:jwt_decoder/jwt_decoder.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:spice_squad/api_endpoints.dart";
import "package:spice_squad/exceptions/email_already_in_use_error.dart";
import "package:spice_squad/exceptions/http_status_exception.dart";
import "package:spice_squad/exceptions/invalid_credentials_error.dart";
import "package:spice_squad/models/user.dart";

/// Repository for user actions
///
/// This class is used to perform user actions like fetching the current user or fetching the id token of the current user.
/// It also stores the current user id and the authentication tokens.
class UserRepository {
  static const _refreshTokenPath = "refreshToken";

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
      return User.fromMap(user);
    } else {
      throw HttpStatusException(response);
    }
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
        throw HttpStatusException(response);
      }
    }
    // Wenn der Token nicht aktualisiert werden konnte, wird er gelöscht
    await _deleteTokens();
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
      throw InvalidCredentialsError();
    } else {
      throw HttpStatusException(response);
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
    await _deleteTokens();
    /*if (response.statusCode != 200) {
      throw HttpStatusException(response);
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
      throw EmailAlreadyInUseError(email);
    } else {
      throw HttpStatusException(response);
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
      throw HttpStatusException(response);
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
      throw HttpStatusException(response);
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
      throw HttpStatusException(response);
    }
  }

  /// Deletes the id token and refresh token
  Future<void> _deleteTokens() async {
    _idToken = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshTokenPath);
  }
}
