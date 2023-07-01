import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/group.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/user.dart";
import "package:spice_squad/services/group_service.dart";
import "package:spice_squad/services/recipe_service.dart";
import "package:spice_squad/services/user_service.dart";

final recipeServiceProvider = AsyncNotifierProvider<RecipeService, List<Recipe>>(RecipeService.new);
final userServiceProvider = AsyncNotifierProvider<UserService, User?>(UserService.new);
final groupServiceProvider = AsyncNotifierProvider<GroupService, List<Group>>(GroupService.new);
