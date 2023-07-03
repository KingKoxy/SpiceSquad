import "package:flutter/material.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/screens/recipe_detail_screen/ingredient_list.dart";
import "package:spice_squad/screens/recipe_detail_screen/label_list.dart";
import "package:spice_squad/widgets/edit_button.dart";
import "package:spice_squad/widgets/favourite_button.dart";
import "package:spice_squad/widgets/portion_amount_field.dart";
import "package:spice_squad/widgets/tag_item.dart";

/// A screen showing the details of a recipe.
class RecipeDetailScreen extends StatefulWidget {
  /// The route name of this screen.
  static const routeName = "/recipe-detail";

  final Recipe recipe;

  /// Creates a new recipe detail screen.
  const RecipeDetailScreen({required this.recipe, super.key});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late int portionAmount;

  @override
  void initState() {
    portionAmount = widget.recipe.defaultPortionAmount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
        actions: const <Widget>[
          EditButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TagItem(image: const AssetImage("assets/icons/person.png"), name: widget.recipe.author.userName),
                  TagItem(
                    image: const AssetImage("assets/icons/calendar.png"),
                    name:
                        "${widget.recipe.uploadDate.day}.${widget.recipe.uploadDate.month}.${widget.recipe.uploadDate.year}",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/images/exampleImage.jpeg",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            LabelList(recipe: widget.recipe),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: PortionAmountField(
                        onChanged: (value) {
                          setState(() {
                            portionAmount = value;
                          });
                        },
                        initialValue: widget.recipe.defaultPortionAmount,),),
                FavouriteButton(
                  value: widget.recipe.isFavourite,
                  onToggle: () {
                    //TODO: Implement favourite toggle
                  },
                ),
              ],
            ),
            Text(
              "Zutaten",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            IngredientList(
                ingredients: widget.recipe.ingredients,
                amountFactor: portionAmount / widget.recipe.defaultPortionAmount,),
            const SizedBox(height: 10),
            Text(
              "Zubereitung",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              widget.recipe.instructions,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
