import "dart:async";
import "dart:io";
import "dart:typed_data";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:image/image.dart";
import "package:spice_squad/models/user.dart";
import "package:spice_squad/providers/repository_providers.dart";
import "package:spice_squad/providers/service_providers.dart";

/// Service that handles all user related logic.
///
/// Every method sets the [state] to update optimistically or indicate loading while executing
class UserService extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    return ref.watch(userRepositoryProvider).fetchCurrentUser();
  }

  /// Tries to login with the given [email] and [password].
  Future<void> login(String email, String password) {
    return ref.read(userRepositoryProvider).login(email, password).then((_) => _refetch());
  }

  /// Logs the user out.
  Future<void> logout() {
    return ref.read(userRepositoryProvider).logout().then((value) => state = const AsyncData(null));
  }

  /// Tries to register with the given [email], [password] and [userName].
  Future<void> register(String email, String password, String userName) {
    return ref.read(userRepositoryProvider).register(email, password, userName).then((_) => _refetch());
  }

  /// Deletes the account of the currently logged in user and logs out.
  Future<void> deleteAccount() {
    return ref.read(userRepositoryProvider).deleteAccount().then((value) {
      return logout();
    });
  }

  /// Requests to reset the password for the account with the given [email].
  Future<void> resetPassword(String email) {
    return ref.read(userRepositoryProvider).resetPassword(email);
  }

  /// Sets the profile image of the currently logged in user to the given [file].
  Future<void> setProfileImage(File file) async {
    if (state.valueOrNull == null) throw Exception("not logged in");
    Image image = decodeImage(file.readAsBytesSync())!;
    image = copyResizeCropSquare(image, size: 240);
    final User oldUser = state.value!;
    String imageUrl;
    if(oldUser.profileImageUrl.isNotEmpty){
      imageUrl = await ref.read(imageRepositoryProvider).updateImage(oldUser.profileImageUrl, encodeJpg(image));
    } else {
      imageUrl = await ref.read(imageRepositoryProvider).uploadImage(encodeJpg(image));
    }
    final User newUser = User(id: oldUser.id, userName: oldUser.userName, profileImageUrl: imageUrl);
    state = AsyncData(newUser);
    return ref.read(userRepositoryProvider).updateUser(newUser).whenComplete(_refetch);
  }

  /// Removes the profile image of the currently logged in user.
  Future<void> removeProfileImage() {
    if (state.valueOrNull == null) throw Exception("not logged in");
    final User oldUser = state.value!;
    final User newUser = User(id: oldUser.id, userName: oldUser.userName, profileImageUrl: "");
    state = AsyncData(newUser);
    return ref.read(userRepositoryProvider).updateUser(newUser).whenComplete(_refetch);
  }

  /// Sets the username of the currently logged in user to the given [value].
  Future<void> setUserName(String value) {
    if (state.valueOrNull == null) throw Exception("not logged in");
    final User oldUser = state.value!;
    final User newUser = User(id: oldUser.id, userName: value, profileImageUrl: oldUser.profileImageUrl);
    state = AsyncData(newUser);
    return ref.read(userRepositoryProvider).updateUser(newUser).whenComplete(_refetch);
  }

  /// Refetches the current user.
  Future<void> _refetch() async {
    await ref.read(userRepositoryProvider).fetchCurrentUser().then((value) async {
      state = AsyncData(value);
    }).whenComplete(() async {
      await ref.read(recipeServiceProvider.notifier).refetch();
      await ref.read(groupServiceProvider.notifier).refetch();
    }).catchError((e) {
      state = AsyncError(e, StackTrace.current);
    });
  }
}
