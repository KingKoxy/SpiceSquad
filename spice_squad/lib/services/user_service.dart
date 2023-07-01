import "dart:async";
import "dart:io";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/user.dart";
import "package:spice_squad/providers/repository_providers.dart";

class UserService extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    return ref.watch(userRepositoryProvider).fetchCurrentUser();
  }

  Future<void> login(String email, String password) {
    return ref.read(userRepositoryProvider).login(email, password).then((value) => _refetch());
  }

  Future<void> logout() {
    state = const AsyncData(null);
    return ref.read(userRepositoryProvider).logout();
  }

  Future<void> register(String email, String password, String userName) {
    return ref.read(userRepositoryProvider).register(email, password, userName).then((value) => _refetch());
  }

  Future<void> deleteAccount() {
    return logout().then((value) {
      return ref.read(userRepositoryProvider).deleteAccount();
    });
  }

  Future<void> resetPassword(String email) {
    return ref.read(userRepositoryProvider).resetPassword(email);
  }

  Future<void> setProfileImage(File image) {
    if (state.valueOrNull == null) throw Exception("not logged in");
    final User oldUser = state.value!;
    final User newUser = User(id: oldUser.id, userName: oldUser.userName, profileImage: image.readAsBytesSync());
    state = AsyncData(newUser);
    return ref.read(userRepositoryProvider).updateUser(newUser).then((value) => _refetch());
  }

  Future<void> removeProfileImage() {
    if (state.valueOrNull == null) throw Exception("not logged in");
    final User oldUser = state.value!;
    final User newUser = User(id: oldUser.id, userName: oldUser.userName, profileImage: null);
    state = AsyncData(newUser);
    return ref.read(userRepositoryProvider).updateUser(newUser).then((value) => _refetch());
  }

  Future<void> setUserName(String value) {
    if (state.valueOrNull == null) throw Exception("not logged in");
    final User oldUser = state.value!;
    final User newUser = User(id: oldUser.id, userName: value, profileImage: oldUser.profileImage);
    state = AsyncData(newUser);
    return ref.read(userRepositoryProvider).updateUser(newUser).then((value) => _refetch());
  }

  Future<void> _refetch() {
    return ref.read(userRepositoryProvider).fetchCurrentUser().then((value) => state = AsyncData(value));
  }
}
