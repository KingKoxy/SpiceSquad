import "package:flutter/cupertino.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/icons.dart";
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
            image: SpiceSquadIconImages.timer,
            name: AppLocalizations.of(context)!.duration(recipe.duration),
          ),
          TagItem(image: SpiceSquadIconImages.flame, name: recipe.difficulty.toString()),
          if (recipe.isVegetarian)
            TagItem(
              image: SpiceSquadIconImages.cheese,
              name: AppLocalizations.of(context)!.labelVegetarian,
            ),
          if (recipe.isVegan)
            TagItem(
              image: SpiceSquadIconImages.avocado,
              name: AppLocalizations.of(context)!.labelVegan,
            ),
          if (recipe.isGlutenFree)
            TagItem(
              image: SpiceSquadIconImages.glutenFree,
              name: AppLocalizations.of(context)!.labelGlutenFree,
            ),
          if (recipe.isHalal)
            TagItem(image: SpiceSquadIconImages.islam, name: AppLocalizations.of(context)!.labelHalal),
          if (recipe.isHalal)
            TagItem(
              image: SpiceSquadIconImages.judaism,
              name: AppLocalizations.of(context)!.labelKosher,
            ),
        ],
      ),
    );
  }
}