import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/screens/recipe_detail_screen/author_date_card.dart";
import "package:spice_squad/screens/recipe_detail_screen/ingredient_list.dart";
import "package:spice_squad/screens/recipe_detail_screen/label_list.dart";
import "package:spice_squad/screens/recipe_detail_screen/portion_amount_Field.dart";
import "package:spice_squad/widgets/edit_button.dart";

import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/user.dart";
import "package:spice_squad/widgets/favourite_button.dart";

class RecipeDetailScreen extends ConsumerStatefulWidget {
  static const routeName = "/recipe-detail";



  const RecipeDetailScreen({super.key});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {

  final TextEditingController _portionController = TextEditingController();
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
          iconId: "iconId",
          amount: 200,
          unit: "g"),
      Ingredient(
          id: "ingredientId",
          name: "Zucker",
          iconId: "iconId",
          amount: 75,
          unit: "g"),
      Ingredient(
          id: "ingredientId",
          name: "Margarine",
          iconId: "iconId",
          amount: 75,
          unit: "g"),
      Ingredient(
          id: "ingredientId",
          name: "Ei(er)",
          iconId: "iconId",
          amount: 200,
          unit: "Stück"),
    ],
    instructions:
    "Die Zutaten für den Knetteig in eine Schüssel geben, rasch zusammenkneten und zur Seite stellen. Für die Füllung Margarine, Zucker, Vanillezucker, Puddingpulver und Eier in einer Schüssel verrühren. Dann den Quark und die saure Sahne untermischen. Die süße Sahne steif schlagen und unterheben.Den Backofen auf 180 °C Ober-/Unterhitze vorheizen.Den Knetteig in einer gefetteten 26er Springform auslegen, etwa 2 - 3 cm am Rand hochziehen. Nun die Füllung in die Form geben, glatt streichen und im heißen Backofen auf der zweiten Schiene von unten 1 Stunde backen.Achtung: Den Kuchen erst nach dem völligen Erkalten aus der Form nehmen, da unmittelbar nach dem Herausnehmen aus dem Backofen die Konsistenz der Quarkmasse noch zu weich ist.",
    defaultPortionAmount: 5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child:
            Text(recipe.title, style: const TextStyle(color: Colors.white)),
          ),
          actions: const <Widget>[
            EditButton(),
          ],
        ),
        body: ListView(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AuthorDateCard(recipe: recipe),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "assets/icons/exampleRecipeImage.jpeg",
                        fit: BoxFit.cover,
                      )),
                  LabelList(labels: _createLabels(recipe)),
                  SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 200,
                              child: PortionAmountField(onChanged: (value) {}, initialValue: recipe.defaultPortionAmount)/*Card(

                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child:
                                  Row(
                                      children: [Container(
                                        width: 100,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius
                                                .horizontal(
                                                left: Radius.circular(8.0))),
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          controller: _portionController,
                                          onChanged: (String newText) {
                                            setState(() {
                                              recipe = _changePortions(this.recipe, int.parse(newText));
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: recipe.defaultPortionAmount.toString(),
                                          ),
                                        ),

                                      ),
                                        Container(
                                            width: 100,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFF4170),
                                                borderRadius: BorderRadius
                                                    .horizontal(
                                                    right: Radius.circular(
                                                        8.0))),
                                            child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Text("Portionen",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFFFFFFFF)),)))),

                                      ]))*/),
                          const Expanded(child: SizedBox()),
                          FavouriteButton(
                              value: recipe.isFavourite, onToggle: () {
                            /* TODO */
                          })
                        ],
                      )),
                  Text(
                    "Zutaten",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline4,
                  ),
                  IngredientList(ingredients: recipe.ingredients),
                  const SizedBox(height: 10),
                  Text(
                    "Zubereitung",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline4,
                  ),
                  Text(
                    recipe.instructions,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText1,
                  ),
                ],
              ),
            )
          ])
        ]));
  }
}

class Label {
  String labelText;
  String labelIcon;

  Label(this.labelText,
      this.labelIcon,);
}

List<Label> _createLabels(Recipe recipe) {
  List<Label> labels = [
    Label("${recipe.duration} min", "assets/icons/clock.png"),
    Label(recipe.difficulty.toString(), "assets/icons/flame.png")
  ];
  if (recipe.isVegetarian) {
    labels.add(Label("Vegetarisch", "assets/icons/vegetarian.png"));
  } else if (recipe.isVegan) {
    labels.add(Label("Vegan", "assets/icons/vegan.png"));
  }
  if (recipe.isGlutenFree) {
    labels.add(Label("Glutenfrei", "assets/icons/gluten_free.png"));
  }
  if (recipe.isHalal) {
    labels.add(Label("Halal", "assets/icons/halal.png"));
  }
  if (recipe.isKosher) {
    labels.add(Label("Koscher", "assets/icons/koscher.png"));
  }
  return labels;
}
Recipe _changePortions(Recipe recipe, int value) {
  late List<Ingredient> ingredients = [];
  for(var i = 0; i < recipe.ingredients.length; i++ ){

    ingredients.add(Ingredient(id: recipe.ingredients[i].id,
        name: recipe.ingredients[i].name,
        iconId: recipe.ingredients[i].iconId,
        amount: (recipe.ingredients[i].amount / recipe.defaultPortionAmount) * value,
        unit: recipe.ingredients[i].unit ));
    }

  Recipe(id: recipe.id, title: recipe.title, author: recipe.author, uploadDate: recipe.uploadDate, duration: recipe.duration, difficulty: recipe.difficulty, isVegetarian: recipe.isVegetarian, isVegan: recipe.isVegan, isGlutenFree: recipe.isGlutenFree, isHalal: recipe.isHalal, isKosher: recipe.isKosher,
      ingredients: ingredients,
      instructions: recipe.instructions,
      defaultPortionAmount: value, isFavourite: recipe.isFavourite, isPrivate: recipe.isPrivate);

    return recipe;
}


