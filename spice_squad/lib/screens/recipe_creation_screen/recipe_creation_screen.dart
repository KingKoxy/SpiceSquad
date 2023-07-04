import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/recipe_creation_data.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/recipe_creation_screen/difficulty_picker_widget.dart";
import "package:spice_squad/screens/recipe_creation_screen/image_picker_widget.dart";
import "package:spice_squad/screens/recipe_creation_screen/ingredient_list.dart";
import "package:spice_squad/screens/recipe_creation_screen/toggleable_label_widget.dart";
import "package:spice_squad/services/recipe_service.dart";
import "package:spice_squad/widgets/nav_bar.dart";
import "package:spice_squad/widgets/portion_amount_field.dart";

/// Screen for creating a new recipe
class RecipeCreationScreen extends StatefulWidget {
  /// Route name for navigation
  static const routeName = "/recipe-creation";

  final _formKey = GlobalKey<FormState>();
  final Recipe? recipe;

  /// Creates a new recipe creation screen
  RecipeCreationScreen({required this.recipe, super.key});

  @override
  State<RecipeCreationScreen> createState() => _RecipeCreationScreenState();
}

class _RecipeCreationScreenState extends State<RecipeCreationScreen> {
  late String _title;
  late int _duration;
  late Difficulty _difficulty;
  late bool _isVegetarian;
  late bool _isVegan;
  late bool _isGlutenFree;
  late bool _isHalal;
  late bool _isKosher;
  late List<Ingredient> _ingredients;
  late String _instructions;
  late int _defaultPortionAmount;
  late Uint8List? _image;

  @override
  void initState() {
    _title = widget.recipe?.title ?? "";
    _duration = widget.recipe?.duration ?? 30;
    _difficulty = widget.recipe?.difficulty ?? Difficulty.easy;
    _isVegetarian = widget.recipe?.isVegetarian ?? false;
    _isVegan = widget.recipe?.isVegan ?? false;
    _isGlutenFree = widget.recipe?.isGlutenFree ?? false;
    _isHalal = widget.recipe?.isHalal ?? false;
    _isKosher = widget.recipe?.isKosher ?? false;
    _ingredients = widget.recipe?.ingredients ?? [];
    _instructions = widget.recipe?.instructions ?? "";
    _defaultPortionAmount = widget.recipe?.defaultPortionAmount ?? 4;
    _image = widget.recipe?.image;

    super.initState();
  }

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
        child: Form(
          key: widget._formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagePickerWidget(
                recipeImage: widget.recipe?.image,
                // TODO Anpassen an den Provider
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Bitte gib einen Titel ein";
                  }
                  return null;
                },
                initialValue: _title,
                onChanged: (value) => _title = value,
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
                      initialActive: _isVegetarian,
                      onChanged: (value) => _isVegetarian = value,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ToggleableLabelWidget(
                      image: const AssetImage("assets/icons/avocado.png"),
                      name: "Vegan",
                      initialActive: _isVegan,
                      onChanged: (value) => _isVegan = value,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ToggleableLabelWidget(
                      image: const AssetImage("assets/icons/glutenFree.png"),
                      name: "Glutenfrei",
                      initialActive: _isGlutenFree,
                      onChanged: (value) => _isGlutenFree = value,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ToggleableLabelWidget(
                      image: const AssetImage("assets/icons/islam.png"),
                      name: "Halal",
                      initialActive: _isHalal,
                      onChanged: (value) => _isHalal = value,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ToggleableLabelWidget(
                      image: const AssetImage("assets/icons/judaism.png"),
                      name: "Koscher",
                      initialActive: _isKosher,
                      onChanged: (value) => _isKosher = value,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Bitte gib eine Dauer ein";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      initialValue: _duration.toString(),
                      textAlign: TextAlign.center,
                      onChanged: (value) => {if (value != "") _duration = int.parse(value)},
                      decoration: const InputDecoration(
                        hintText: "Dauer",
                        suffixText: "min",
                        prefixIcon: ImageIcon(AssetImage("assets/icons/clock.png")),
                        prefixIconColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(child: SizedBox(height: 54, child: DifficultyPickerWidget(initialValue: _difficulty)))
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              PortionAmountField(
                onChanged: (value) {},
                initialValue: widget.recipe?.defaultPortionAmount ?? 4,
              ),
              const SizedBox(
                height: 16,
              ),
              IngredientList(ingredients: widget.recipe?.ingredients ?? []),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Zubereitung",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Bitte gib eine Zubereitungsbeschreibung ein";
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                onChanged: (value) => _instructions = value,
                initialValue: _instructions,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Zubereitungbeschreibung",
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: Consumer(
                  builder: (context, ref, child) => ElevatedButton(
                    onPressed: () {
                      if (widget._formKey.currentState?.validate() == null) {
                        saveRecipe(ref.read(recipeServiceProvider.notifier));
                      }
                    },
                    child: const Text("Speichern"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveRecipe(RecipeService recipeService) {
    final RecipeCreationData recipe = RecipeCreationData(
      title: _title,
      duration: _duration,
      instructions: _instructions,
      defaultPortionAmount: _defaultPortionAmount,
      ingredients: _ingredients,
      isGlutenFree: _isGlutenFree,
      isHalal: _isHalal,
      isKosher: _isKosher,
      isVegan: _isVegan,
      isVegetarian: _isVegetarian,
      image: _image,
      difficulty: _difficulty,
    );
    recipeService.createRecipe(recipe).then((value) => Navigator.of(context).pop());
  }
}
