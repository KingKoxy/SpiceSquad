import 'dart:math';
import '../models/user.dart';

class UserRepository {
  Future<User> fetchCurrentUser() async {
    final Random random = Random();
    return Future.delayed(
        const Duration(milliseconds: 2000),
        () => User(
            id: "userId",
            userName: {"Konrad", "Lukas", "Henri", "Raphael"}
                .elementAt(random.nextInt(4))));
  }
}
