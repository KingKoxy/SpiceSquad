import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/repository_providers.dart';

import '../models/recipe.dart';

class RecipeService extends AsyncNotifier<List<Recipe>> {
  @override
  FutureOr<List<Recipe>> build() {
    return ref.watch(remoteRecipeRepositoryProvider).fetchAllRecipesForUser();
  }

  Future<void> createRecipe(Recipe recipe) {
    //TODO: implement recipe creation
    throw UnimplementedError();
  }

  Future<void> deleteRecipe(String recipeId) {
    //TODO: implement recipe deletion
    throw UnimplementedError();
  }

  Future<void> updateRecipe(Recipe recipe) {
    //TODO: implement recipe updating
    throw UnimplementedError();
  }

  Future<void> toggleFavourite(Recipe recipe) {
    //TODO: implement favourite toggling
    throw UnimplementedError();
  }

  Future<void> togglePrivate(Recipe recipe) {
    //TODO: implement private toggling
    throw UnimplementedError();
  }

  Future<void> reportRecipe(String recipeId) {
    //TODO: implement recipe reporting
    throw UnimplementedError();
  }

  Future<void> exportRecipe(Recipe recipe) {
    //TODO: implement recipe exporting
    throw UnimplementedError();
  }
}
