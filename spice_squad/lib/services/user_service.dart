import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/repository_providers.dart';

import '../models/user.dart';

class UserService extends AsyncNotifier<User?> {
  @override
  FutureOr<User> build() {
    return ref.watch(userRepositoryProvider).fetchCurrentUser();
  }

  Future<void> login(String email, String password) {
    //TODO: implement login
    throw UnimplementedError();
  }

  Future<void> logout() {
    //TODO: implement logout
    throw UnimplementedError();
  }

  Future<void> register(String email, String password, String userName) {
    //TODO: implement register
    throw UnimplementedError();
  }

  Future<void> deleteAccount() {
    //TODO: implement account deletion
    throw UnimplementedError();
  }

  Future<void> resetPassword(String email) {
    //TODO: implement password resetting
    throw UnimplementedError();
  }

  Future<void> setProfileImage(File image) {
    //TODO: implement account deletion
    throw UnimplementedError();
  }

  Future<void> removeProfileImage() {
    //TODO: implement profile image removal
    throw UnimplementedError();
  }

  Future<void> setUserName(String value) {
    //TODO: implement username setting
    throw UnimplementedError();
  }
}
