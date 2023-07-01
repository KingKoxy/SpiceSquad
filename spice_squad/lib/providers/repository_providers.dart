import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/repositories/admin_repository.dart';
import 'package:spice_squad/repositories/group_repository.dart';
import 'package:spice_squad/repositories/ingredient_name_repository.dart';
import 'package:spice_squad/repositories/remote_recipe_repository.dart';
import 'package:spice_squad/repositories/user_repository.dart';

final ingredientNameRepositoryProvider = Provider<IngredientNameRepository>((ref) => IngredientNameRepository());
final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());
final remoteRecipeRepositoryProvider =
    Provider<RemoteRecipeRepository>((ref) => RemoteRecipeRepository(ref.watch(userRepositoryProvider)));
final groupRepositoryProvider = Provider<GroupRepository>((ref) => GroupRepository(ref.watch(userRepositoryProvider)));
final adminRepositoryProvider = Provider<AdminRepository>((ref) => AdminRepository(ref.watch(userRepositoryProvider)));
