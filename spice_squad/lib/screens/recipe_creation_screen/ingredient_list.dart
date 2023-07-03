import "package:flutter/material.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/screens/ingredient_creation_screen/ingredient_creation_screen.dart";
import "package:spice_squad/widgets/add_button.dart";
import "package:spice_squad/widgets/favourite_button.dart";
import "package:spice_squad/widgets/remove_button.dart";

class IngredientList extends StatefulWidget {
  final List<Ingredient> ingredients;

  const IngredientList({required this.ingredients, super.key});

  @override
  State<IngredientList> createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  late List<Ingredient> _ingredients;

  @override
  void initState() {
    _ingredients = widget.ingredients;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Zutaten",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            AddButton(
              onPressed: () {
                Navigator.pushNamed(context, IngredientCreationScreen.routeName).then((value) => setState(() {
                      if (value != null) _ingredients.add(value as Ingredient);
                    }));
              },
            ),
          ],
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: _ingredients.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _ingredients.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          IngredientCreationScreen.routeName,
                          arguments: _ingredients[index],
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.asset(
                                _ingredients[index].iconId,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Row(
                                children: [
                                  Text(
                                    _ingredients[index].name,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("•"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${_ingredients[index].amount} ${_ingredients[index].unit}",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            RemoveButton(onPressed: (){
                              setState(() {
                                _ingredients.removeAt(index);
                              });
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Bisher hast du noch keine Zutate hinzugefügt.",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                  ),
                ),
        ),
      ],
    );
  }
}
