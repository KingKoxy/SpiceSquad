import 'dart:math';
import 'dart:typed_data';
import '../models/difficulty.dart';
import '../models/group.dart';
import '../models/group_member.dart';
import '../models/group_recipe.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/user.dart';

class GroupRepository {
  Future<List<Group>> fetchAllGroupsForUser() async {
    final Random random = Random();
    return Future.delayed(
        const Duration(milliseconds: 2000),
        () => List.generate(
            5 + random.nextInt(5),
            (_) => Group(
                  id: "groupId",
                  name: {
                    "Backen",
                    "WG",
                    "Karlsruher Intellektuelle",
                    "BDSM Club"
                  }.elementAt(random.nextInt(4)),
                  groupCode: "groupCode",
                  members: List.generate(
                      random.nextInt(20),
                      (_) => GroupMember(
                          isAdmin: random.nextBool(),
                          user: User(
                              id: "userId",
                              userName: {"Konrad", "Lukas", "Henri", "Raphael"}
                                  .elementAt(random.nextInt(4))))),
                  recipes: List.generate(
                      random.nextInt(20),
                      (_) => GroupRecipe(
                          recipe: Recipe(
                            id: "recipeId",
                            title: {"Lasagne", "Pizza", "Spagghetti"}
                                .elementAt(random.nextInt(3)),
                            image: random.nextBool() ? Uint8List(1) : null,
                            author: User(
                                id: "userId",
                                userName: {
                                  "Konrad",
                                  "Lukas",
                                  "Henri",
                                  "Raphael"
                                }.elementAt(random.nextInt(4))),
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
}
