import "dart:async";
import "dart:io";
import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/user.dart";
import "package:spice_squad/providers/repository_providers.dart";

/// Service that handles all user related logic.
///
/// Every method sets the [state] to update optimistically or indicate loading while executing
class UserService extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    debugPrint("UserService.build()");
    return ref.watch(userRepositoryProvider).fetchCurrentUser();
  }

  /// Tries to login with the given [email] and [password].
  Future<void> login(String email, String password) {
    return ref.read(userRepositoryProvider).login(email, password).then((value) => _refetch());
  }

  /// Logs the user out.
  Future<void> logout() {
    state = const AsyncData(null);
    return ref.read(userRepositoryProvider).logout();
  }

  /// Tries to register with the given [email], [password] and [userName].
  Future<void> register(String email, String password, String userName) {
    return ref.read(userRepositoryProvider).register(email, password, userName).then((value) => _refetch());
  }

  /// Deletes the account of the currently logged in user and logs out.
  Future<void> deleteAccount() {
    return logout().then((value) {
      return ref.read(userRepositoryProvider).deleteAccount();
    });
  }

  /// Requests to reset the password for the account with the given [email].
  Future<void> resetPassword(String email) {
    return ref.read(userRepositoryProvider).resetPassword(email);
  }

  /// Sets the profile image of the currently logged in user to the given [image].
  Future<void> setProfileImage(File image) {
    if (state.valueOrNull == null) throw Exception("not logged in");
    final User oldUser = state.value!;
    final User newUser = User(id: oldUser.id, userName: oldUser.userName, profileImage: image.readAsBytesSync());
    state = AsyncData(newUser);
    return ref.read(userRepositoryProvider).updateUser(newUser).then((value) => _refetch());
  }

  /// Removes the profile image of the currently logged in user.
  Future<void> removeProfileImage() {
    if (state.valueOrNull == null) throw Exception("not logged in");
    final User oldUser = state.value!;
    final User newUser = User(id: oldUser.id, userName: oldUser.userName, profileImage: null);
    state = AsyncData(newUser);
    return ref.read(userRepositoryProvider).updateUser(newUser).then((value) => _refetch());
  }

  /// Sets the username of the currently logged in user to the given [value].
  Future<void> setUserName(String value) {
    if (state.valueOrNull == null) throw Exception("not logged in");
    final User oldUser = state.value!;
    final User newUser = User(id: oldUser.id, userName: value, profileImage: oldUser.profileImage);
    state = AsyncData(newUser);
    return ref.read(userRepositoryProvider).updateUser(newUser).then((value) => _refetch());
  }

  /// Refetches the current user.
  Future<void> _refetch() {
    return ref.read(userRepositoryProvider).fetchCurrentUser().then((value) => state = AsyncData(value));
  }
}
