class Ingredient {
  final String id;
  final String name;
  final String iconId;
  final double amount;
  final String unit;

  Ingredient(
      {required this.id,
      required this.name,
      required this.iconId,
      required this.amount,
      required this.unit});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
        id: json["id"],
        name: json["name"],
        iconId: json["iconId"],
        amount: json["amount"],
        unit: json["unit"]);
  }
}
