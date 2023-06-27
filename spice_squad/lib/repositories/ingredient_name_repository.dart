class IngredientNameRepository {
  Future<List<String>> fetchIngredientNames() {
    return Future.delayed(const Duration(milliseconds: 2000),
        () => List.generate(100, (index) => index.toString()));
  }
}
