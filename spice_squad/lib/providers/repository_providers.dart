import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/repositories/admin_repository.dart";
import "package:spice_squad/repositories/group_repository.dart";
import "package:spice_squad/repositories/ingredient_data_repository.dart";
import "package:spice_squad/repositories/recipe_repository.dart";
import "package:spice_squad/repositories/user_repository.dart";

/// Provider for the [IngredientNameRepository]
final ingredientDataRepository = Provider<IngredientDataRepository>((ref) => IngredientDataRepository());

/// Provider for the [UserRepository]
final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());

/// Provider for the [RecipeRepository]
final recipeRepositoryProvider =
    Provider<RecipeRepository>((ref) => RecipeRepository(ref.watch(userRepositoryProvider)));

/// Provider for the [GroupRepository]
final groupRepositoryProvider = Provider<GroupRepository>((ref) => GroupRepository(ref.watch(userRepositoryProvider)));

/// Provider for the [AdminRepository]
final adminRepositoryProvider = Provider<AdminRepository>((ref) => AdminRepository(ref.watch(userRepositoryProvider)));
