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

  Future<List<String>> fetchIngredientNames() {
    return Future.delayed(const Duration(milliseconds: 2000), () => Future(() => _ingredients));
  }
}
