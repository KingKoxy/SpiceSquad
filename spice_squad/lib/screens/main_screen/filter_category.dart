import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/recipe.dart";

enum FilterCategory {
  favourite,
  difficultyEasy,
  difficultyMedium,
  difficultyHard,
  labelVegetarian,
  labelVegan,
  labelGlutenFree,
  labelHalal,
  labelKosher;

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

  @override
  String toString() {
    switch (this) {
      case FilterCategory.favourite:
        return "Favorit";
      case FilterCategory.difficultyEasy:
        return "Schwierigkeit Einfach";
      case FilterCategory.difficultyMedium:
        return "Schwierigkeit Mittel";
      case FilterCategory.difficultyHard:
        return "Schwierigkeit Schwer";
      case FilterCategory.labelVegetarian:
        return "Vegetarisch";
      case FilterCategory.labelVegan:
        return "Vegan";
      case FilterCategory.labelGlutenFree:
        return "Glutenfrei";
      case FilterCategory.labelHalal:
        return "Halal";
      case FilterCategory.labelKosher:
        return "Koscher";
    }
  }
}
