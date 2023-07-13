import "dart:typed_data";

/// Model for an ingredient
class Ingredient {
  /// The id of the ingredient
  final String id;

  /// The name of the ingredient
  final String name;

  /// The icon id of the ingredient
  final Uint8List icon;

  /// The amount of the ingredient
  final double amount;

  /// The unit of the ingredient
  final String unit;

  /// Creates a new [Ingredient] with the given [id], [name], [icon], [amount], and [unit]
  Ingredient({
    required this.id,
    required this.name,
    required this.icon,
    required this.amount,
    required this.unit,
  });

  /// Creates a new [Ingredient] from the given [map] object by extracting the values
  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map["id"],
      name: map["name"],
      icon: map["icon"],
      amount: map["amount"],
      unit: map["unit"],
    );
  }

  /// Converts this [Ingredient] to a [Map] object by inserting the values
  static Map<String, dynamic> toMap(Ingredient ingredient) {
    return {
      "id": ingredient.id,
      "name": ingredient.name,
      "icon": ingredient.icon,
      "amount": ingredient.amount,
      "unit": ingredient.unit,
    };
  }


}
