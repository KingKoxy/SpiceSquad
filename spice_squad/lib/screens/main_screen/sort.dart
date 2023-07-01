import "package:spice_squad/screens/main_screen/sort_category.dart";

/// Class that represents a sort with its category and direction.
class Sort {
  /// Whether the sort is ascending or descending.
  final bool ascending;

  /// The category to sort by.
  final SortCategory category;

  /// Creates a new sort.
  Sort({this.ascending = true, this.category = SortCategory.title});
}
