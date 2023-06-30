import 'dart:async';
import 'dart:math';
import 'package:spice_squad/models/user.dart';

class UserRepository {
  String? _userId = "userId";
  String? _idToken;
  String? _refreshToken;

  Future<User?> fetchCurrentUser() async {
    final Random random = Random();
    var user = await Future.delayed(const Duration(milliseconds: 2000),
        () => User(id: "userId", userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4))));
    _userId = user.id;
    return user;
  }

  String? getUserId() {
    return _userId;
  }

  FutureOr<String?> getToken() {
    throw UnimplementedError();
    if (_idToken != null || _isExpired(_idToken!)) {
      //Try fetching id token with refreshtoken or return null
    }
    return _idToken;
  }

  String? _getRefreshToken() {
    //TODO: implement fetching refreshtoken from systemstorage
    throw UnimplementedError();
    return _refreshToken ?? "";
  }

  bool _isExpired(String token) {
    throw UnimplementedError();
  }

  Future<void> login(String email, String password) async {
    //TODO: implement login
    throw new UnimplementedError();
  }

  Future<void> logout() async {
    //TODO: implement logout
    throw new UnimplementedError();
  }

  Future<void> register(String email, String password, String userName) async {
    //TODO: implement register
    throw new UnimplementedError();
  }

  Future<void> updateUser(User user) async {
    //TODO: implement user updating
    throw new UnimplementedError();
  }

  Future<void> deleteAccount() async {
    //TODO: implement account deletion
    throw new UnimplementedError();
  }

  Future<void> resetPassword(String email) async {
    //TODO: implement password resetting
    throw new UnimplementedError();
  }
}
