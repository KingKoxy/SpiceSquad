import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/screens/recipe_detail_screen/author_date_card.dart";
import "package:spice_squad/screens/recipe_detail_screen/ingredient_list.dart";
import "package:spice_squad/screens/recipe_detail_screen/label_list.dart";
import "package:spice_squad/screens/recipe_detail_screen/portion_amount_Field.dart";
import "package:spice_squad/widgets/edit_button.dart";
import "package:spice_squad/widgets/favourite_button.dart";
import "package:spice_squad/widgets/tag_item.dart";

/// A screen showing the details of a recipe.
class RecipeDetailScreen extends ConsumerStatefulWidget {
  /// The route name of this screen.
  static const routeName = "/recipe-detail";

  /// Creates a new recipe detail screen.
  const RecipeDetailScreen({super.key});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  final TextEditingController _portionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(recipe.title),
        actions: const <Widget>[
          EditButton(),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
              // ListView(
              //   shrinkWrap: true,
              //   scrollDirection: Axis.horizontal,
              //   semanticChildCount: 2,
              //   children: [
              //     TagItem(image: const AssetImage("assets/icons/person.png"), name: recipe.author.userName),
              //     TagItem(
              //       image: const AssetImage("assets/icons/calendar.png"),
              //       name: "${recipe.uploadDate.day}.${recipe.uploadDate.month}.${recipe.uploadDate.year}",
              //     ),
              //   ],
              // ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    "assets/images/exampleImage.jpeg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              LabelList(labels: _createLabels(recipe)),
              SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 200,
                          child: PortionAmountField(
                              onChanged: (value) {},
                              initialValue: recipe
                                  .defaultPortionAmount) /*Card(

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

                                          ]))*/
                          ),
                      const Expanded(child: SizedBox()),
                      FavouriteButton(
                          value: recipe.isFavourite,
                          onToggle: () {
                            /* TODO */
                          })
                    ],
                  )),
              Text(
                "Zutaten",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              IngredientList(ingredients: recipe.ingredients),
              const SizedBox(height: 10),
              Text(
                "Zubereitung",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                recipe.instructions,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class Label {
  String labelText;
  String labelIcon;

  Label(
    this.labelText,
    this.labelIcon,
  );
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
  for (var i = 0; i < recipe.ingredients.length; i++) {
    ingredients.add(Ingredient(
        id: recipe.ingredients[i].id,
        name: recipe.ingredients[i].name,
        iconId: recipe.ingredients[i].iconId,
        amount: (recipe.ingredients[i].amount / recipe.defaultPortionAmount) * value,
        unit: recipe.ingredients[i].unit));
  }

  Recipe(
      id: recipe.id,
      title: recipe.title,
      author: recipe.author,
      uploadDate: recipe.uploadDate,
      duration: recipe.duration,
      difficulty: recipe.difficulty,
      isVegetarian: recipe.isVegetarian,
      isVegan: recipe.isVegan,
      isGlutenFree: recipe.isGlutenFree,
      isHalal: recipe.isHalal,
      isKosher: recipe.isKosher,
      ingredients: ingredients,
      instructions: recipe.instructions,
      defaultPortionAmount: value,
      isFavourite: recipe.isFavourite,
      isPrivate: recipe.isPrivate);

  return recipe;
}
