import "dart:async";

import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/recipe_creation_data.dart";
import "package:spice_squad/providers/repository_providers.dart";
import "package:spice_squad/services/pdf_exporter.dart";

/// Service that handles all recipe related logic.
///
/// Every method sets the [state] to update optimistically or indicate loading while executing
class RecipeService extends AsyncNotifier<List<Recipe>> {
  @override
  FutureOr<List<Recipe>> build() {
    return ref.watch(recipeRepositoryProvider).fetchAllRecipesForUser();
  }

  /// Creates a new recipe with the given [recipe].
  Future<void> createRecipe(RecipeCreationData recipe) {
    state = const AsyncLoading();
    return ref.read(recipeRepositoryProvider).createRecipe(recipe).whenComplete(refetch);
  }

  /// Deletes the recipe with the given [recipeId].
  Future<void> deleteRecipe(String recipeId) {
    if (state.valueOrNull == null) throw Exception("state not set");
    final List<Recipe> list = state.value!;
    list.removeWhere((element) => element.id == recipeId);
    state = AsyncData(list);
    return ref.read(recipeRepositoryProvider).deleteRecipe(recipeId).whenComplete(refetch);
  }

  /// Updates the recipe with the same id with the given [recipe].
  Future<void> updateRecipe(Recipe recipe) {
    _updateSingleRecipe(recipe.id, (oldRecipe) => recipe);
    return ref.read(recipeRepositoryProvider).updateRecipe(recipe).whenComplete(refetch);
  }

  /// Toggles the favourite status of the given [recipe].
  Future<void> toggleFavourite(Recipe recipe) {
    _updateSingleRecipe(
      recipe.id,
      (oldRecipe) => oldRecipe.copyWith(
        isFavourite: !oldRecipe.isFavourite,
      ),
    );
    return ref.read(recipeRepositoryProvider).setFavourite(recipe.id, !recipe.isFavourite).whenComplete(refetch);
  }

  /// Toggles the private status of the given [recipe].
  Future<void> togglePrivate(Recipe recipe) {
    final Recipe updatedRecipe = _updateSingleRecipe(
      recipe.id,
      (oldRecipe) => oldRecipe.copyWith(isPrivate: !oldRecipe.isPrivate),
    );
    return ref.read(recipeRepositoryProvider).updateRecipe(updatedRecipe).whenComplete(refetch);
  }

  /// Reports the recipe with the given [recipeId].
  Future<void> reportRecipe(String recipeId) {
    return ref.read(recipeRepositoryProvider).reportRecipe(recipeId);
  }

  /// Exports the given [recipe] as a pdf.
  Future<Uint8List> exportRecipe(Recipe recipe, AppLocalizations appLocalizations) {
    return PDFExporter.exportRecipe(recipe, appLocalizations);
  }

  /// Refetches all recipes.
  FutureOr<void> refetch() {
    ref.read(recipeRepositoryProvider).fetchAllRecipesForUser().then((value) {
      state = AsyncData(value);
    }).catchError((e) {
      state = AsyncError(e, StackTrace.current);
    });
  }

  /// Updates the recipe with the given [recipeId] with the given [updatingFunction] in the [state] and returns the updated recipe.
  Recipe _updateSingleRecipe(String recipeId, Recipe Function(Recipe oldRecipe) updatingFunction) {
    if (state.valueOrNull == null) throw Exception("state not set");
    final List<Recipe> list = state.value!;
    final int oldRecipeIndex = list.indexWhere((recipe) => recipe.id == recipeId);
    final Recipe oldRecipe = list.removeAt(oldRecipeIndex);
    final Recipe newRecipe = updatingFunction(oldRecipe);
    list.insert(oldRecipeIndex, newRecipe);
    state = AsyncData(list);
    return newRecipe;
  }
}
