import "dart:async";
import "dart:math";
import "package:jwt_decoder/jwt_decoder.dart";
import "package:shared_preferences/shared_preferences.dart";
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
    final Random random = Random();
    final user = await Future.delayed(
      const Duration(milliseconds: 2000),
      () => User(id: "userId", userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4))),
    );
    _userId = user.id;
    return user;
  }

  /// Gets the user id that has been obtained by the [fetchCurrentUser] method or returns null if the user is not logged in
  String? getUserId() {
    return _userId;
  }

  /// Fetches the id token of the current user or returns null if the user is not logged in or the token is expired
  Future<FutureOr<String?>> getToken() async {
    if (_idToken == null || _isExpired(_idToken!)) {
      final String? refreshToken = await _getRefreshToken();
      if (refreshToken != null && !_isExpired(refreshToken)) {
        //TODO: Get new token
      }
      await logout();
      throw Exception("User is not logged in");
    }
    return _idToken;
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
    //TODO: implement login
    throw UnimplementedError();
  }

  /// Logs out the user and deletes the id token and refresh token
  Future<void> logout() async {
    _userId = null;
    _idToken = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshTokenPath);
    //TODO: implement logout
    throw UnimplementedError();
  }

  /// Registers a new user with the given email, password and username and logs the user in
  Future<void> register(String email, String password, String userName) async {
    //TODO: implement register
    throw UnimplementedError();
  }

  /// Updates the current user with the given user on the server
  Future<void> updateUser(User user) async {
    //TODO: implement user updating
    throw UnimplementedError();
  }

  /// Deletes the current users account from the server
  Future<void> deleteAccount() async {
    //TODO: implement account deletion
    throw UnimplementedError();
  }

  /// Requests a password reset for the given email
  Future<void> resetPassword(String email) async {
    //TODO: implement password resetting
    throw UnimplementedError();
  }
}
