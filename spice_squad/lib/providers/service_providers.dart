import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/services/group_service.dart';
import 'package:spice_squad/services/recipe_service.dart';
import 'package:spice_squad/services/user_service.dart';

import '../models/group.dart';
import '../models/recipe.dart';
import '../models/user.dart';

final recipeServiceProvider =
    AsyncNotifierProvider<RecipeService, List<Recipe>>(() => RecipeService());
final userServiceProvider =
    AsyncNotifierProvider<UserService, User?>(() => UserService());
final groupServiceProvider =
    AsyncNotifierProvider<GroupService, List<Group>>(() => GroupService());
