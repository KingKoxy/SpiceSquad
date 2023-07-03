/// Repository for fetching ingredient names.
///
/// This class is used to fetch ingredient names from the backend.
class IngredientNameRepository {
  static const _ingredients = [
    "Mehl",
    "Eier",
    "Hackfleisch",
    "Zucker",
    "Auberginen",
    "Kartoffeln",
    "Meerrettich",
    "Hähnchenbrust"
  ];

  /// Fetches all ingredient names
  Future<List<String>> fetchIngredientNames() {
    return Future.delayed(const Duration(milliseconds: 2000), () => Future(() => _ingredients));
  }
}
