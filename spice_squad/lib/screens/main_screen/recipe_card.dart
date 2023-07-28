import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/recipe_detail_screen/recipe_detail_screen.dart";
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).pushNamed(RecipeDetailScreen.routeName, arguments: recipe),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          recipe.author.userName,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  FavouriteButton(
                    value: recipe.isFavourite,
                    onToggle: () {
                      _toggleFavourite(ref.read(recipeServiceProvider.notifier));
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
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
                              ? Image.memory(recipe.image!, fit: BoxFit.cover)
                              : const Center(
                                  child: ImageIcon(SpiceSquadIconImages.image, size: 32),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const ImageIcon(
                                  SpiceSquadIconImages.timer,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.duration(recipe.duration),
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const ImageIcon(
                                  SpiceSquadIconImages.flame,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  recipe.difficulty.getName(context),
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              ],
                            ),
                          ),
                        ),
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
