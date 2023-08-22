import "package:flutter/cupertino.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/widgets/tag_item.dart";

/// A widget that displays a list of labels.
class LabelList extends StatelessWidget {
  /// The recipe whose labels are displayed.
  final Recipe _recipe;

  /// Creates a new [LabelList].
  const LabelList({required Recipe recipe, super.key}) : _recipe = recipe;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TagItem(
            image: SpiceSquadIconImages.timer,
            name: AppLocalizations.of(context)!.duration(_recipe.duration),
          ),
          const SizedBox(
            width: 8,
          ),
          TagItem(image: SpiceSquadIconImages.flame, name: _recipe.difficulty.getName(AppLocalizations.of(context)!)),
          if (_recipe.isVegetarian) ...[
            const SizedBox(
              width: 8,
            ),
            TagItem(
              image: SpiceSquadIconImages.cheese,
              name: AppLocalizations.of(context)!.labelVegetarian,
            ),
          ],
          if (_recipe.isVegan) ...[
            const SizedBox(
              width: 8,
            ),
            TagItem(
              image: SpiceSquadIconImages.avocado,
              name: AppLocalizations.of(context)!.labelVegan,
            ),
          ],
          if (_recipe.isGlutenFree) ...[
            const SizedBox(
              width: 8,
            ),
            TagItem(
              image: SpiceSquadIconImages.glutenFree,
              name: AppLocalizations.of(context)!.labelGlutenFree,
            ),
          ],
          if (_recipe.isHalal) ...[
            const SizedBox(
              width: 8,
            ),
            TagItem(image: SpiceSquadIconImages.islam, name: AppLocalizations.of(context)!.labelHalal),
          ],
          if (_recipe.isKosher) ...[
            const SizedBox(
              width: 8,
            ),
            TagItem(
              image: SpiceSquadIconImages.judaism,
              name: AppLocalizations.of(context)!.labelKosher,
            ),
          ],
        ],
      ),
    );
  }
}
