import "package:flutter/cupertino.dart";
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
  String getName(BuildContext context) {
    switch (this) {
      case FilterCategory.favourite:
        return AppLocalizations.of(context)!.filterNameFavourite;
      case FilterCategory.difficultyEasy:
        return AppLocalizations.of(context)!.filterNameDifficultyEasy;
      case FilterCategory.difficultyMedium:
        return AppLocalizations.of(context)!.filterNameDifficultyMedium;
      case FilterCategory.difficultyHard:
        return AppLocalizations.of(context)!.filterNameDifficultyHard;
      case FilterCategory.labelVegetarian:
        return AppLocalizations.of(context)!.filterNameLabelVegetarian;
      case FilterCategory.labelVegan:
        return AppLocalizations.of(context)!.filterNameLabelVegan;
      case FilterCategory.labelGlutenFree:
        return AppLocalizations.of(context)!.filterNameLabelGlutenFree;
      case FilterCategory.labelHalal:
        return AppLocalizations.of(context)!.filterNameLabelHalal;
      case FilterCategory.labelKosher:
        return AppLocalizations.of(context)!.filterNameLabelKosher;
    }
  }
}
