import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/repositories/admin_repository.dart";
import "package:spice_squad/repositories/group_repository.dart";
import "package:spice_squad/repositories/image_repository.dart";
import "package:spice_squad/repositories/ingredient_data_repository.dart";
import "package:spice_squad/repositories/recipe_repository.dart";
import "package:spice_squad/repositories/user_repository.dart";

/// Provider for the [IngredientDataRepository]
final ingredientDataRepository = Provider<IngredientDataRepository>((ref) => IngredientDataRepository());

/// Provider for the [UserRepository]
final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());

/// Provider for the [RecipeRepository]
final recipeRepositoryProvider =
    Provider<RecipeRepository>((ref) => RecipeRepository(userRepository: ref.watch(userRepositoryProvider)));

/// Provider for the [GroupRepository]
final groupRepositoryProvider =
    Provider<GroupRepository>((ref) => GroupRepository(userRepository: ref.watch(userRepositoryProvider)));

/// Provider for the [AdminRepository]
final adminRepositoryProvider =
    Provider<AdminRepository>((ref) => AdminRepository(userRepository: ref.watch(userRepositoryProvider)));

/// Provider for the [ImageRepository]
final imageRepositoryProvider =
    Provider<ImageRepository>((ref) => ImageRepository(userRepository: ref.watch(userRepositoryProvider)));
