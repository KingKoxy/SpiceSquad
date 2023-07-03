import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/user.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/recipe_creation_screen/difficulty-picker_widget.dart";
import "package:spice_squad/screens/recipe_creation_screen/image_picker_widget.dart";
import "package:spice_squad/screens/recipe_creation_screen/ingredient_list_creation.dart";
import "package:spice_squad/screens/recipe_creation_screen/label.dart";
import "package:spice_squad/screens/recipe_creation_screen/label_picker.dart";

import "package:spice_squad/widgets/portion_amount_field.dart";

/// Screen for creating a new recipe
class RecipeCreationScreen extends ConsumerWidget {
  /// Route name for navigation
  static const routeName = "/recipe-creation";

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  Recipe recipe = Recipe(
    id: "recipeId",
    title: "Lasagne mit ganz viel Käse",
    image: null,
    author: User(id: "userId", userName: "Konrad "),
    //Konrad Henri Lukas RaphaelKonrad
    uploadDate: DateTime.now(),
    duration: 500,
    difficulty: Difficulty.hard,
    isVegetarian: false,
    isVegan: true,
    isGlutenFree: true,
    isPrivate: true,
    isFavourite: false,
    isKosher: true,
    isHalal: true,
    ingredients: [
      Ingredient(
          id: "ingredientId",
          name: "Mehl",
          iconId: "assets/icons/vegetarian.png",
          amount: 200,
          unit: "g",),
      Ingredient(
          id: "ingredientId",
          name: "Zucker",
          iconId: "assets/icons/vegetarian.png",
          amount: 75,
          unit: "g",),
      Ingredient(
          id: "ingredientId",
          name: "Margarine",
          iconId: "assets/icons/vegetarian.png",
          amount: 75,
          unit: "g",),
      Ingredient(
          id: "ingredientId",
          name: "Ei(er)",
          iconId: "assets/icons/vegetarian.png",
          amount: 200,
          unit: "Stück",),
    ],
    instructions:
        "Die Zutaten für den Knetteig in eine Schüssel geben, rasch zusammenkneten und zur Seite stellen. Für die Füllung Margarine, Zucker, Vanillezucker, Puddingpulver und Eier in einer Schüssel verrühren. Dann den Quark und die saure Sahne untermischen. Die süße Sahne steif schlagen und unterheben.Den Backofen auf 180 °C Ober-/Unterhitze vorheizen.Den Knetteig in einer gefetteten 26er Springform auslegen, etwa 2 - 3 cm am Rand hochziehen. Nun die Füllung in die Form geben, glatt streichen und im heißen Backofen auf der zweiten Schiene von unten 1 Stunde backen.Achtung: Den Kuchen erst nach dem völligen Erkalten aus der Form nehmen, da unmittelbar nach dem Herausnehmen aus dem Backofen die Konsistenz der Quarkmasse noch zu weich ist.",
    defaultPortionAmount: 5,
  );
  Label label = Label("Vegetarisch", "assets/icons/vegetarian.png");

  /// Creates a new recipe creation screen
  RecipeCreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _instructionsController.text = recipe.instructions;
    _durationController.text = recipe.duration.toString();
    _titleController.text = recipe.title;

    return Scaffold(
        appBar: AppBar(
            title: const FittedBox(
                fit: BoxFit.fitWidth,
                child: Text("Rezept erstellen",
                    style: TextStyle(color: Colors.white),),),),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(padding: const EdgeInsets.all(16), children: [
                  ref.watch(recipeServiceProvider).when(
                        data: (recipe) {
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ImagePickerWidget(
                                    recipeImage: recipe[0].image,
                                    // TODO Anpassen an den Provider
                                    recipeService: ref
                                        .read(recipeServiceProvider.notifier),),
                              ],);
                        },
                        error: (error, stackTrace) => Text(error.toString()),
                        loading: () => const Column(
                          children: [CircularProgressIndicator()],
                        ),
                      ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: "Rezepttitel"),
                  ),
                  const SizedBox(height: 8,),
                  LabelPicker(labels: createLabels(recipe), recipe: recipe),
                  SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 150,
                              height: 50,
                              child: TextFormField(
                                controller: _durationController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration:
                                    const InputDecoration(hintText: "Dauer"),
                              ),),
                          const Expanded(child: SizedBox()),
                          DifficultyPickerWidget(difficulty: recipe.difficulty)
                        ],
                      ),),
                  PortionAmountField(
                    onChanged: (value) {},
                    initialValue: recipe.defaultPortionAmount,
                  ),
                  IngredientListCreation(ingredients: recipe.ingredients),
                  const SizedBox(height: 8,),
                  Text("Zubereitung",
                      style: Theme.of(context).textTheme.headlineMedium,),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _instructionsController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: "Zubereitungbeschreibung",),
                  ),
                ],),),),);
  }
}
