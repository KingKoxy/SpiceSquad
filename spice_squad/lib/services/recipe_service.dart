import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/repository_providers.dart';

import '../models/recipe.dart';

class RecipeService extends AsyncNotifier<List<Recipe>>{
  @override
  FutureOr<List<Recipe>> build() {
    return ref.watch(remoteRecipeRepositoryProvider).fetchAllRecipesForUser();
  }
}