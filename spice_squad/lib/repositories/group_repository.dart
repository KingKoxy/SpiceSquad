import "dart:io";
import "dart:math";
import "dart:typed_data";
import "package:http/http.dart" as http;
import "package:spice_squad/api_endpoints.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/group.dart";
import "package:spice_squad/models/group_member.dart";
import "package:spice_squad/models/group_recipe.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/user.dart";
import "package:spice_squad/repositories/user_repository.dart";

/// Repository for group actions
///
/// This class is used to perform group actions like fetching all groups for a user or fetching a group by its id.
class GroupRepository {
  final UserRepository _userRepository;

  /// Creates a new [GroupRepository] with the given [UserRepository]
  GroupRepository(this._userRepository);

  /// Fetches all groups for the current user
  Future<List<Group>> fetchAllGroupsForUser() async {
    final Random random = Random();
    return Future.delayed(
      const Duration(milliseconds: 2000),
      () => List.generate(
        random.nextInt(8),
        (_) => Group(
          id: "groupId",
          name: {"Backen", "WG", "Karlsruher Intellektuelle", "BDSM Club"}.elementAt(random.nextInt(4)),
          groupCode: "1234-5678",
          members: List.generate(
            random.nextInt(20),
            (_) => GroupMember(
              isAdmin: random.nextBool(),
              user: User(
                id: "userId",
                profileImage: random.nextBool() ? null : Uint8List(1),
                userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4)),
              ),
            ),
          ),
          recipes: List.generate(
            random.nextInt(20),
            (_) => GroupRecipe(
              recipe: Recipe(
                id: "recipeId",
                title: {"Lasagne", "Pizza", "Spaghetti"}.elementAt(random.nextInt(3)),
                image: random.nextBool() ? Uint8List(1) : null,
                author: User(
                  id: "userId",
                  userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4)),
                ),
                uploadDate: DateTime.now(),
                duration: random.nextInt(120),
                difficulty: Difficulty.values[random.nextInt(3)],
                isVegetarian: random.nextBool(),
                isVegan: random.nextBool(),
                isGlutenFree: random.nextBool(),
                isPrivate: random.nextBool(),
                isFavourite: random.nextBool(),
                isKosher: random.nextBool(),
                isHalal: random.nextBool(),
                ingredients: [
                  Ingredient(
                    id: "ingredientId",
                    name: "Mehl",
                    iconId: "iconId",
                    amount: random.nextDouble() * 200,
                    unit: "g",
                  )
                ],
                instructions: "Instructions",
                defaultPortionAmount: random.nextInt(8),
              ),
              isCensored: random.nextBool(),
            ),
          ),
        ),
      ),
    );
  }

  /// Fetches the group with the given [id]
  Future<Group> fetchGroupById(String id) {
    final Random random = Random();

    return Future.delayed(
      const Duration(milliseconds: 2000),
      () => Group(
        id: id,
        name: {"Backen", "WG", "Karlsruher Intellektuelle", "BDSM Club"}.elementAt(random.nextInt(4)),
        groupCode: "1234-5678",
        members: List.generate(
          1 + random.nextInt(12),
          (_) => GroupMember(
            isAdmin: random.nextBool(),
            user: User(
              id: "userId",
              profileImage: random.nextBool() ? null : Uint8List(1),
              userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4)),
            ),
          ),
        ),
        recipes: List.generate(
          //random.nextInt(10)
          random.nextInt(1),
          (_) => GroupRecipe(
            recipe: Recipe(
              id: "recipeId",
              title: {"Lasagne", "Pizza", "Spaghetti"}.elementAt(random.nextInt(3)),
              image: random.nextBool() ? Uint8List(1) : null,
              author: User(
                id: "userId",
                userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4)),
              ),
              uploadDate: DateTime.now(),
              duration: random.nextInt(120),
              difficulty: Difficulty.values[random.nextInt(3)],
              isVegetarian: random.nextBool(),
              isVegan: random.nextBool(),
              isGlutenFree: random.nextBool(),
              isPrivate: random.nextBool(),
              isFavourite: random.nextBool(),
              isKosher: random.nextBool(),
              isHalal: random.nextBool(),
              ingredients: [
                Ingredient(
                  id: "ingredientId",
                  name: "Mehl",
                  iconId: "iconId",
                  amount: random.nextDouble() * 200,
                  unit: "g",
                )
              ],
              instructions: "Instructions",
              defaultPortionAmount: random.nextInt(8),
            ),
            isCensored: random.nextBool(),
          ),
        ),
      ),
    );
  }

  /// Makes the current user join the group with the given [groupCode]
  Future<void> joinGroup(String groupCode) async {
    await http.patch(
      Uri.parse(ApiEndpoints.joinGroup),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${await _userRepository.getToken()}",
      },
      body: {
        "groupCode": groupCode,
      },
    );
  }

  /// Makes the current user leave the group with the given [groupId]
  Future<List<Group>> leaveGroup(String groupId) {
    //TODO: implement group leaving
    throw UnimplementedError();
  }

  /// Creates a new group with the given [name]
  Future<List<Group>> createGroup(String name) {
    //TODO: implement group creation
    throw UnimplementedError();
  }

  /// Updates the given [group] by overwriting the group on the server with the same id
  Future<List<Group>> updateGroup(Group group) {
    //TODO: implement group updating
    throw UnimplementedError();
  }

  /// Deletes the group with the given [groupId]
  Future<List<Group>> deleteGroup(String groupId) {
    //TODO: implement group deletion
    throw UnimplementedError();
  }
}
