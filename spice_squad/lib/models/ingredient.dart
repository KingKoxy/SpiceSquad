import "dart:typed_data";

/// Model for an ingredient
class Ingredient {
  /// The id of the ingredient
  ///
  /// If the ingredient is not yet saved in the database, the id is an empty string
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
  ///
  /// The [map] should have the following structure
  /// ```dart
  /// {
  ///   "id": String,
  ///   "name": String,
  ///   "icon": {
  ///     "data": Uint8List
  ///   },
  ///   "amount": double,
  ///   "unit": String
  /// }
  /// ```
  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map["id"],
      name: map["name"],
      icon: Uint8List.fromList(map["icon"]["data"].cast<int>()),
      amount: map["amount"].toDouble(),
      unit: map["unit"],
    );
  }

  /// Converts this [Ingredient] to a [Map] object by inserting the values
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "icon": icon,
      "amount": amount,
      "unit": unit,
    };
  }
}
