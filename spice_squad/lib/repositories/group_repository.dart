import 'dart:math';
import 'dart:typed_data';
import 'package:spice_squad/repositories/user_repository.dart';

import 'package:spice_squad/models/difficulty.dart';
import 'package:spice_squad/models/group.dart';
import 'package:spice_squad/models/group_member.dart';
import 'package:spice_squad/models/group_recipe.dart';
import 'package:spice_squad/models/ingredient.dart';
import 'package:spice_squad/models/recipe.dart';
import 'package:spice_squad/models/user.dart';

class GroupRepository {
  final UserRepository _userRepository;

  GroupRepository(this._userRepository);

  Future<List<Group>> fetchAllGroupsForUser() async {
    final Random random = Random();
    return Future.delayed(
        const Duration(milliseconds: 2000),
        () => List.generate(
            5 + random.nextInt(5),
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
                              userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4))))),
                  recipes: List.generate(
                      random.nextInt(20),
                      (_) => GroupRecipe(
                          recipe: Recipe(
                            id: "recipeId",
                            title: {"Lasagne", "Pizza", "Spaghetti"}.elementAt(random.nextInt(3)),
                            image: random.nextBool() ? Uint8List(1) : null,
                            author: User(
                                id: "userId",
                                userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4))),
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
                                  unit: "g")
                            ],
                            instructions: 'Instructions',
                            defaultPortionAmount: random.nextInt(8),
                          ),
                          isCensored: random.nextBool())),
                )));
  }

  Future<Group> fetchGroupById(String id) {
    final Random random = Random();

    return Future.delayed(
      const Duration(milliseconds: 2000),
      () => Group(
        id: id,
        name: {"Backen", "WG", "Karlsruher Intellektuelle", "BDSM Club"}.elementAt(random.nextInt(4)),
        groupCode: "1234-5678",
        members: List.generate(
            3 + random.nextInt(12),
            (_) => GroupMember(
                isAdmin: random.nextBool(),
                user: User(
                    id: "userId",
                    profileImage: random.nextBool() ? null : Uint8List(1),
                    userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4))))),
        recipes: List.generate(
            random.nextInt(20),
            (_) => GroupRecipe(
                recipe: Recipe(
                  id: "recipeId",
                  title: {"Lasagne", "Pizza", "Spaghetti"}.elementAt(random.nextInt(3)),
                  image: random.nextBool() ? Uint8List(1) : null,
                  author: User(
                      id: "userId", userName: {"Konrad", "Lukas", "Henri", "Raphael"}.elementAt(random.nextInt(4))),
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
                        unit: "g")
                  ],
                  instructions: 'Instructions',
                  defaultPortionAmount: random.nextInt(8),
                ),
                isCensored: random.nextBool())),
      ),
    );
  }

  Future<List<Group>> joinGroup(String groupCode) {
    //TODO: implement group joining
    throw UnimplementedError();
  }

  Future<List<Group>> leaveGroup(String groupId) {
    //TODO: implement group leaving
    throw UnimplementedError();
  }

  Future<List<Group>> createGroup(String name) {
    //TODO: implement group creation
    throw UnimplementedError();
  }

  Future<List<Group>> updateGroup(Group group) {
    //TODO: implement group updating
    throw UnimplementedError();
  }

  Future<List<Group>> deleteGroup(String groupId) {
    //TODO: implement group deletion
    throw UnimplementedError();
  }
}
