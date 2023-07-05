import "dart:async";
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
    return ref.watch(remoteRecipeRepositoryProvider).fetchAllRecipesForUser();
  }

  /// Creates a new recipe with the given [recipe].
  Future<void> createRecipe(RecipeCreationData recipe) {
    state = const AsyncLoading();
    return ref.read(remoteRecipeRepositoryProvider).createRecipe(recipe).then((value) => _refetch());
  }

  /// Deletes the recipe with the given [recipeId].
  Future<void> deleteRecipe(String recipeId) {
    if (state.valueOrNull == null) throw Exception("state not set");
    final List<Recipe> list = state.value!;
    list.removeWhere((element) => element.id == recipeId);
    state = AsyncData(list);
    return ref.read(remoteRecipeRepositoryProvider).deleteRecipe(recipeId).then((value) => _refetch());
  }

  /// Updates the recipe with the same id with the given [recipe].
  Future<void> updateRecipe(Recipe recipe) {
    _updateSingleRecipe(recipe.id, (oldRecipe) => recipe);
    return ref.read(remoteRecipeRepositoryProvider).updateRecipe(recipe).then((value) => _refetch());
  }

  /// Toggles the favourite status of the given [recipe].
  Future<void> toggleFavourite(Recipe recipe) {
    _updateSingleRecipe(
      recipe.id,
      (oldRecipe) => Recipe(
        id: oldRecipe.id,
        title: oldRecipe.title,
        author: oldRecipe.author,
        uploadDate: oldRecipe.uploadDate,
        duration: oldRecipe.duration,
        defaultPortionAmount: oldRecipe.defaultPortionAmount,
        difficulty: oldRecipe.difficulty,
        isVegetarian: oldRecipe.isVegetarian,
        isVegan: oldRecipe.isVegan,
        isGlutenFree: oldRecipe.isGlutenFree,
        isHalal: oldRecipe.isHalal,
        isKosher: oldRecipe.isKosher,
        ingredients: oldRecipe.ingredients,
        instructions: oldRecipe.instructions,
        isFavourite: !oldRecipe.isFavourite,
        image: oldRecipe.image,
        isPrivate: oldRecipe.isPrivate,
      ),
    );
    return ref
        .read(remoteRecipeRepositoryProvider)
        .setFavourite(recipe.id, !recipe.isFavourite)
        .then((value) => _refetch());
  }

  /// Toggles the private status of the given [recipe].
  Future<void> togglePrivate(Recipe recipe) {
    final Recipe updatedRecipe = _updateSingleRecipe(
      recipe.id,
      (oldRecipe) => Recipe(
        id: oldRecipe.id,
        title: oldRecipe.title,
        author: oldRecipe.author,
        uploadDate: oldRecipe.uploadDate,
        duration: oldRecipe.duration,
        defaultPortionAmount: oldRecipe.defaultPortionAmount,
        difficulty: oldRecipe.difficulty,
        isVegetarian: oldRecipe.isVegetarian,
        isVegan: oldRecipe.isVegan,
        isGlutenFree: oldRecipe.isGlutenFree,
        isHalal: oldRecipe.isHalal,
        isKosher: oldRecipe.isKosher,
        ingredients: oldRecipe.ingredients,
        instructions: oldRecipe.instructions,
        isFavourite: oldRecipe.isFavourite,
        image: oldRecipe.image,
        isPrivate: !oldRecipe.isPrivate,
      ),
    );
    return ref.read(remoteRecipeRepositoryProvider).updateRecipe(updatedRecipe).then((value) => _refetch());
  }

  /// Reports the recipe with the given [recipeId].
  Future<void> reportRecipe(String recipeId) {
    return ref.read(remoteRecipeRepositoryProvider).reportRecipe(recipeId);
  }

  /// Exports the given [recipe] as a pdf.
  Future<void> exportRecipe(Recipe recipe) {
    return PDFExporter.exportRecipe(recipe);
  }

  /// Refetches all recipes.
  Future<void> _refetch() {
    return ref.read(remoteRecipeRepositoryProvider).fetchAllRecipesForUser().then((value) => state = AsyncData(value));
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
