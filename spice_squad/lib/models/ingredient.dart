/// Model for an ingredient
class Ingredient {
  /// The id of the ingredient
  final String id;

  /// The name of the ingredient
  final String name;

  /// The icon id of the ingredient
  final String iconId;

  /// The amount of the ingredient
  final double amount;

  /// The unit of the ingredient
  final String unit;

  /// Creates a new [Ingredient] with the given [id], [name], [iconId], [amount], and [unit]
  Ingredient({
    required this.id,
    required this.name,
    required this.iconId,
    required this.amount,
    required this.unit,
  });

  /// Creates a new [Ingredient] from the given [map] object by extracting the values
  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map["id"],
      name: map["name"],
      iconId: map["iconId"],
      amount: map["amount"],
      unit: map["unit"],
    );
  }
}
