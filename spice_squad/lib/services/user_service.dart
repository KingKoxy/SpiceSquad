import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/repository_providers.dart';
import 'package:spice_squad/models/user.dart';

class UserService extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    return ref.watch(userRepositoryProvider).fetchCurrentUser();
  }

  Future<void> login(String email, String password) {
    return ref.read(userRepositoryProvider).login(email, password);
  }

  Future<void> logout() {
    return ref.read(userRepositoryProvider).logout();
  }

  Future<void> register(String email, String password, String userName) {
    return ref.read(userRepositoryProvider).register(email, password, userName);
  }

  Future<void> deleteAccount() {
    return ref.read(userRepositoryProvider).deleteAccount();
  }

  Future<void> resetPassword(String email) {
    return ref.read(userRepositoryProvider).resetPassword(email);
  }

  Future<void> setProfileImage(File image) {
    return ref.read(userRepositoryProvider).fetchCurrentUser().then((oldUser) {
      if (oldUser == null) {
        throw Exception("not logged in");
      } else {
        return ref
            .read(userRepositoryProvider)
            .updateUser(User(id: oldUser.id, userName: oldUser.userName, profileImage: image.readAsBytesSync()));
      }
    });
  }

  Future<void> removeProfileImage() {
    return ref.read(userRepositoryProvider).fetchCurrentUser().then((oldUser) {
      if (oldUser == null) {
        throw Exception("not logged in");
      } else {
        return ref
            .read(userRepositoryProvider)
            .updateUser(User(id: oldUser.id, userName: oldUser.userName, profileImage: null));
      }
    });
  }

  Future<void> setUserName(String value) {
    return ref.read(userRepositoryProvider).fetchCurrentUser().then((oldUser) {
      if (oldUser == null) {
        throw Exception("not logged in");
      } else {
        return ref
            .read(userRepositoryProvider)
            .updateUser(User(id: oldUser.id, userName: value, profileImage: oldUser.profileImage));
      }
    });
  }
}
