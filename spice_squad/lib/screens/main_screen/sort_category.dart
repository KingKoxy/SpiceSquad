import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/models/recipe.dart";

/// Enum for the different sort categories.
enum SortCategory {
  /// Sort by title.
  title,

  /// Sort by difficulty.
  difficulty,

  /// Sort by duration.
  duration,

  /// Sort by creation date.
  creationDate;

  /// Compares two recipes by the sort category. This can be used by the [List.sort()] method.
  int compare(Recipe a, Recipe b) {
    switch (this) {
      case SortCategory.title:
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      case SortCategory.difficulty:
        return a.difficulty.index - b.difficulty.index;
      case SortCategory.duration:
        return a.duration - b.duration;
      case SortCategory.creationDate:
        return a.uploadDate.compareTo(b.uploadDate);
    }
  }

  /// Returns the string representation of the sort category.
  String getName(AppLocalizations appLocalizations) {
    switch (this) {
      case SortCategory.title:
        return appLocalizations.sortNameTitle;
      case SortCategory.difficulty:
        return appLocalizations.sortNameDifficulty;
      case SortCategory.duration:
        return appLocalizations.sortNameDuration;
      case SortCategory.creationDate:
        return appLocalizations.sortNameDate;
    }
  }
}
