import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/screens/ingredient_creation_screen/ingredient_creation_screen.dart";
import "package:spice_squad/widgets/add_button.dart";
import "package:spice_squad/widgets/ingredient_list_item.dart";

/// Widget for displaying a list of ingredients
class IngredientList extends StatefulWidget {
  /// The ingredients to display
  final List<Ingredient> _initialList;

  /// Callback for when the list changes
  final ValueChanged<List<Ingredient>> _onChanged;

  /// Creates a new ingredient list
  const IngredientList({
    required List<Ingredient> initialList,
    required void Function(List<Ingredient>) onChanged,
    super.key,
  })  : _onChanged = onChanged,
        _initialList = initialList;

  @override
  State<IngredientList> createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  late List<Ingredient> _ingredients;

  @override
  void initState() {
    super.initState();
    _ingredients = List.of(widget._initialList);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    print("Building ingredient list");
    return Column(
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.ingredientListHeadline,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            AddButton(
              onPressed: () {
                Navigator.pushNamed(context, IngredientCreationScreen.routeName).then(
                  (value) => setState(() {
                    if (value != null) {
                      _ingredients.add(value as Ingredient);
                      widget._onChanged(_ingredients);
                    }
                  }),
                );
                print("Add ingredient");
              },
            ),
          ],
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: _ingredients.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _ingredients.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        final temp = await Navigator.pushNamed(
                          context,
                          IngredientCreationScreen.routeName,
                          arguments: _ingredients[index],
                        ) as Ingredient?;
                        if (temp == null) return;
                        setState(() {
                          _ingredients[index] = temp;
                          widget._onChanged(_ingredients);
                        });
                      },
                      child: IngredientListItem(
                        ingredient: _ingredients[index],
                        onRemove: () {
                          setState(() {
                            _ingredients.removeAt(index);
                            widget._onChanged(_ingredients);
                          });
                        },
                      ),
                    );
                  },
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context)!.noIngredientsAddedMessage,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                  ),
                ),
        ),
      ],
    );
  }
}
