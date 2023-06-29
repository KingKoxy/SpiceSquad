import 'dart:math';
import '../models/user.dart';

class UserRepository {
  String? _userId = "userId";
  String? _token;

  Future<User> fetchCurrentUser() async {
    final Random random = Random();
    var user = await Future.delayed(const Duration(milliseconds: 2000),
        () => User(id: "userId", userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4))));
    _userId = user.id;
    return user;
  }

  String? getUserId() {
    return _userId;
  }
}
