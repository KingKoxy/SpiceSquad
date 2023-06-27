import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/repository_providers.dart';

import '../models/user.dart';

class UserService extends AsyncNotifier<User?> {
  @override
  FutureOr<User> build() {
    return ref.watch(userRepositoryProvider).fetchCurrentUser();
  }
}
