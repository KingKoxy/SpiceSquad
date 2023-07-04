import "package:flutter/material.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/screens/recipe_creation_screen/image_picker_widget.dart";
import "package:spice_squad/screens/recipe_creation_screen/ingredient_list.dart";
import "package:spice_squad/screens/recipe_creation_screen/toggleable_label_widget.dart";
import "package:spice_squad/widgets/nav_bar.dart";

import "package:spice_squad/widgets/portion_amount_field.dart";

/// Screen for creating a new recipe
class RecipeCreationScreen extends StatelessWidget {
  /// Route name for navigation
  static const routeName = "/recipe-creation";

  final Recipe? recipe;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  /// Creates a new recipe creation screen
  RecipeCreationScreen({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(
        currentIndex: 0,
      ),
      appBar: AppBar(
        title: const Text(
          "Rezept erstellen",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImagePickerWidget(
              recipeImage: recipe?.image,
              // TODO Anpassen an den Provider
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: "Rezepttitel"),
            ),
            const SizedBox(
              height: 16,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ToggleableLabelWidget(
                    image: const AssetImage("assets/icons/milk.png"),
                    name: "Vegetarisch",
                    initialActive: recipe?.isVegetarian ?? false,
                    onChanged: (value) {},
                  ),
                  ToggleableLabelWidget(
                    image: const AssetImage("assets/icons/avocado.png"),
                    name: "Vegan",
                    initialActive: recipe?.isVegan ?? false,
                    onChanged: (value) {},
                  ),
                  ToggleableLabelWidget(
                    image: const AssetImage("assets/icons/glutenFree.png"),
                    name: "Glutenfrei",
                    initialActive: recipe?.isGlutenFree ?? false,
                    onChanged: (value) {},
                  ),
                  ToggleableLabelWidget(
                    image: const AssetImage("assets/icons/islam.png"),
                    name: "Halal",
                    initialActive: recipe?.isHalal ?? false,
                    onChanged: (value) {},
                  ),
                  ToggleableLabelWidget(
                    image: const AssetImage("assets/icons/judaism.png"),
                    name: "Koscher",
                    initialActive: recipe?.isKosher ?? false,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            /*Row(
              children: [
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: "Dauer"),
                ),
                DifficultyPickerWidget(difficulty: recipe?.difficulty ?? Difficulty.medium)
              ],
            ),*/
            PortionAmountField(
              onChanged: (value) {},
              initialValue: recipe?.defaultPortionAmount ?? 4,
            ),
            IngredientList(ingredients: recipe?.ingredients ?? []),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Zubereitung",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _instructionsController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Zubereitungbeschreibung",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
