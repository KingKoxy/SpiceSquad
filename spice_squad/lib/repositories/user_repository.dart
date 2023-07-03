import "dart:async";
import "dart:math";
import "package:spice_squad/models/user.dart";

/// Repository for user actions
///
/// This class is used to perform user actions like fetching the current user or fetching the id token of the current user.
/// It also stores the current user id and the authentication tokens.
class UserRepository {
  String? _userId = "userId";
  String? _idToken;
  String? _refreshToken;

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

  /// Fetches the current user id
  String? getUserId() {
    return _userId;
  }

  /// Fetches the id token of the current user or returns null if the user is not logged in or the token is expired
  FutureOr<String?> getToken() {
    if (_idToken == null || _isExpired(_idToken!)) {
      final String? refreshToken = _getRefreshToken();
      if (refreshToken != null && !_isExpired(refreshToken)) {
        //Get new token
      }
      throw UnimplementedError();
    }
    return _idToken;
  }

  /// Returns the refresh token of the current user by fetching it from the system storage or returns null if none is available
  String? _getRefreshToken() {
    //TODO: implement fetching refreshtoken from systemstorage
    return _refreshToken;
  }

  /// Returns true if the given token is expired
  bool _isExpired(String token) {
    //TODO: implement isExpired(token)
    throw UnimplementedError();
  }

  /// Tries to login the user and setting the id token and refresh token
  Future<void> login(String email, String password) async {
    //TODO: implement login
    throw UnimplementedError();
  }

  /// Logs out the user and deletes the id token and refresh token
  Future<void> logout() async {
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
