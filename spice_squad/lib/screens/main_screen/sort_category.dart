import "package:spice_squad/models/recipe.dart";

enum SortCategory {
  title,
  difficulty,
  creationDate;

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
