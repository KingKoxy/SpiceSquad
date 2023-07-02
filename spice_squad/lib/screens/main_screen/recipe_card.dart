import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/recipe_detail_screen.dart";
import "package:spice_squad/services/recipe_service.dart";
import "package:spice_squad/widgets/favourite_button.dart";

/// A card showing a recipe.
class RecipeCard extends ConsumerWidget {
  /// The recipe to show.
  final Recipe recipe;

  /// Creates a new recipe card.
  const RecipeCard({required this.recipe, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(RecipeDetailScreen.routeName, arguments: recipe),
      child: Card(
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
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        recipe.author.userName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  FavouriteButton(
                    value: recipe.isFavourite,
                    onToggle: () {
                      _toggleFavourite(ref.read(recipeServiceProvider.notifier));
                    },
                  ),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: recipe.image != null
                              ? Image.asset(
                                  "assets/images/exampleImage.jpeg",
                                  fit: BoxFit.cover,
                                )
                              : //Image.memory(recipe.image!, fit: BoxFit.cover)
                              Center(
                                  child: SizedBox(height: 32, width: 32, child: Image.asset("assets/icons/image.png")),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
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
                                Image.asset(
                                  "assets/icons/clock.png",
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  AppLocalizations.of(context)!.duration(recipe.duration),
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/icons/flame.png"),
                                const SizedBox(width: 8),
                                Text(
                                  recipe.difficulty.toString(),
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleFavourite(RecipeService recipeService) {
    recipeService.toggleFavourite(recipe);
  }
}
