import "package:spice_squad/models/recipe.dart";

/// Enum for the different sort categories.
enum SortCategory {
  /// Sort by title.
  title,

  /// Sort by difficulty.
  difficulty,

  /// Sort by creation date.
  creationDate;

  /// Compares two recipes by the sort category. This can be used by the [List.sort()] method.
  int compare(Recipe a, Recipe b) {
    switch (this) {
      case SortCategory.title:
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      case SortCategory.difficulty:
        return a.difficulty.index - b.difficulty.index;
      case SortCategory.creationDate:
        return a.uploadDate.compareTo(b.uploadDate);
    }
  }

  @override
  String toString() {
    switch (this) {
      case SortCategory.title:
        return "Titel";
      case SortCategory.difficulty:
        return "Schwierigkeit";
      case SortCategory.creationDate:
        return "Datum";
    }
  }
}
