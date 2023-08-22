import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/recipe.dart";

/// Enum for the different filter categories.
enum FilterCategory {
  /// Filter for favourite recipes.
  favourite,

  /// Filter for easy recipes.
  difficultyEasy,

  /// Filter for medium recipes.
  difficultyMedium,

  /// Filter for hard recipes.
  difficultyHard,

  /// Filter for vegetarian recipes.
  labelVegetarian,

  /// Filter for vegan recipes.
  labelVegan,

  /// Filter for gluten free recipes.
  labelGlutenFree,

  /// Filter for halal recipes.
  labelHalal,

  /// Filter for kosher recipes.
  labelKosher;

  /// Returns whether or not a recipe matches the filter category.
  bool matches(Recipe recipe) {
    switch (this) {
      case FilterCategory.favourite:
        return recipe.isFavourite;
      case FilterCategory.difficultyEasy:
        return recipe.difficulty == Difficulty.easy;
      case FilterCategory.difficultyMedium:
        return recipe.difficulty == Difficulty.medium;
      case FilterCategory.difficultyHard:
        return recipe.difficulty == Difficulty.hard;
      case FilterCategory.labelVegetarian:
        return recipe.isVegetarian;
      case FilterCategory.labelVegan:
        return recipe.isVegan;
      case FilterCategory.labelGlutenFree:
        return recipe.isGlutenFree;
      case FilterCategory.labelHalal:
        return recipe.isHalal;
      case FilterCategory.labelKosher:
        return recipe.isKosher;
    }
  }

  /// Returns the string representation of the filter category.
  String getName(AppLocalizations appLocalizations) {
    switch (this) {
      case FilterCategory.favourite:
        return appLocalizations.filterNameFavourite;
      case FilterCategory.difficultyEasy:
        return appLocalizations.filterNameDifficultyEasy;
      case FilterCategory.difficultyMedium:
        return appLocalizations.filterNameDifficultyMedium;
      case FilterCategory.difficultyHard:
        return appLocalizations.filterNameDifficultyHard;
      case FilterCategory.labelVegetarian:
        return appLocalizations.filterNameLabelVegetarian;
      case FilterCategory.labelVegan:
        return appLocalizations.filterNameLabelVegan;
      case FilterCategory.labelGlutenFree:
        return appLocalizations.filterNameLabelGlutenFree;
      case FilterCategory.labelHalal:
        return appLocalizations.filterNameLabelHalal;
      case FilterCategory.labelKosher:
        return appLocalizations.filterNameLabelKosher;
    }
  }
}
