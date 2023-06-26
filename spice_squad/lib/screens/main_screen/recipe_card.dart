import 'package:flutter/material.dart';
import 'package:spice_squad/models/recipe.dart';
import 'package:spice_squad/widgets/favourite_button.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      recipe.author.userName,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                FavouriteButton(
                    value: recipe.isFavourite,
                    onToggle: () {
                      /*TODO: toggle favourite*/
                    }),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 130,
                    child: Card(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: recipe.image != null
                            ? Image.asset(
                                "assets/icons/exampleRecipeImage.jpeg",
                                fit: BoxFit.cover,
                              )
                            : //Image.memory(recipe.image!, fit: BoxFit.cover)
                            Center(
                                child: SizedBox(
                                    height: 32,
                                    width: 32,
                                    child:
                                        Image.asset("assets/icons/image.png")),
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/icons/clock.png",),
                              const SizedBox(width: 8),
                              Text("${recipe.duration} min", style: Theme.of(context).textTheme.subtitle1,)
                            ],
                          ),
                        ),
                      ),
                      Card(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/icons/flame.png"),
                              const SizedBox(width: 8),
                              Text(recipe.difficulty.toString(), style: Theme.of(context).textTheme.subtitle1,)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
