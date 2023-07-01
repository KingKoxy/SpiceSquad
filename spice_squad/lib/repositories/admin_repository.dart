import "package:spice_squad/repositories/user_repository.dart";

class AdminRepository {
  final UserRepository _userRepository;

  AdminRepository(this._userRepository);

  Future<void> makeAdmin(String userId, String groupId) {
    //TODO: implement admin making
    throw UnimplementedError();
  }

  Future<void> removeAdminStatus(String userId, String groupId) {
    //TODO: implement admin removing
    throw UnimplementedError();
  }

  Future<void> kickUser(String userId, String groupId) {
    //TODO: implement user kicking
    throw UnimplementedError();
  }

  Future<void> banUser(String userId, String groupId) {
    //TODO: implement user banning
    throw UnimplementedError();
  }

  Future<void> setCensored(String recipeId, String groupId, bool value) {
    //TODO: implement recipe censoring
    throw UnimplementedError();
  }
}
