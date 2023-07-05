import "package:flutter/cupertino.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
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
          TagItem(
              image: const AssetImage("assets/icons/clock.png"),
              name: AppLocalizations.of(context)!.duration(recipe.duration),),
          TagItem(image: const AssetImage("assets/icons/flame.png"), name: recipe.difficulty.toString()),
          if (recipe.isVegetarian)
            TagItem(
                image: const AssetImage("assets/icons/milk.png"), name: AppLocalizations.of(context)!.labelVegetarian,),
          if (recipe.isVegan)
            TagItem(
                image: const AssetImage("assets/icons/avocado.png"), name: AppLocalizations.of(context)!.labelVegan,),
          if (recipe.isGlutenFree)
            TagItem(
                image: const AssetImage("assets/icons/glutenFree.png"),
                name: AppLocalizations.of(context)!.labelGlutenFree,),
          if (recipe.isHalal)
            TagItem(image: const AssetImage("assets/icons/islam.png"), name: AppLocalizations.of(context)!.labelHalal),
          if (recipe.isHalal)
            TagItem(
                image: const AssetImage("assets/icons/judaism.png"), name: AppLocalizations.of(context)!.labelKosher,),
        ],
      ),
    );
  }
}
