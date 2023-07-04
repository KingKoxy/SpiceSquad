import "package:flutter/cupertino.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/widgets/tag_item.dart";

/// A widget that displays a list of labels.
class LabelList extends StatelessWidget {
  /// The recipe whose labels are displayed.
  final Recipe recipe;

  /// Creates a new [LabelList].
  const LabelList({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TagItem(image: const AssetImage("assets/icons/clock.png"), name: "${recipe.duration} min"),
          TagItem(image: const AssetImage("assets/icons/flame.png"), name: recipe.difficulty.toString()),
          if (recipe.isVegetarian) const TagItem(image: AssetImage("assets/icons/milk.png"), name: "Vegetarisch"),
          if (recipe.isVegan) const TagItem(image: AssetImage("assets/icons/avocado.png"), name: "Vegan"),
          if (recipe.isGlutenFree)
            const TagItem(image: AssetImage("assets/icons/glutenFree.png"), name: "Glutenfrei"),
          if (recipe.isHalal) const TagItem(image: AssetImage("assets/icons/islam.png"), name: "Halal"),
          if (recipe.isHalal) const TagItem(image: AssetImage("assets/icons/judaism.png"), name: "Koscher"),
        ],
      ),
    );
  }
}
