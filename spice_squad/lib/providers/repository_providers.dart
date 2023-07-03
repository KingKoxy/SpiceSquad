import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/repositories/admin_repository.dart";
import "package:spice_squad/repositories/group_repository.dart";
import "package:spice_squad/repositories/ingredient_name_repository.dart";
import "package:spice_squad/repositories/remote_recipe_repository.dart";
import "package:spice_squad/repositories/user_repository.dart";

/// Provider for the [IngredientNameRepository]
final ingredientNameRepositoryProvider = Provider<IngredientNameRepository>((ref) => IngredientNameRepository());

/// Provider for the [UserRepository]
final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());

/// Provider for the [RemoteRecipeRepository]
final remoteRecipeRepositoryProvider =
    Provider<RemoteRecipeRepository>((ref) => RemoteRecipeRepository(ref.watch(userRepositoryProvider)));

/// Provider for the [GroupRepository]
final groupRepositoryProvider = Provider<GroupRepository>((ref) => GroupRepository(ref.watch(userRepositoryProvider)));

/// Provider for the [AdminRepository]
final adminRepositoryProvider = Provider<AdminRepository>((ref) => AdminRepository(ref.watch(userRepositoryProvider)));
