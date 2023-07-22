import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/recipe_creation_screen/recipe_creation_screen.dart";
import "package:spice_squad/screens/recipe_detail_screen/ingredient_list.dart";
import "package:spice_squad/screens/recipe_detail_screen/label_list.dart";
import "package:spice_squad/widgets/favourite_button.dart";
import "package:spice_squad/widgets/portion_amount_field.dart";
import "package:spice_squad/widgets/tag_item.dart";

/// A screen showing the details of a recipe.
class RecipeDetailScreen extends ConsumerStatefulWidget {
  /// The route name of this screen.
  static const routeName = "/recipe-detail";

  /// The recipe that is displayed on this screen.
  final Recipe recipe;

  /// Creates a new recipe detail screen.
  const RecipeDetailScreen({required this.recipe, super.key});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  late int portionAmount;
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    portionAmount = widget.recipe.defaultPortionAmount;
    isFavourite = widget.recipe.isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.recipe.title),
          actions: widget.recipe.author.id == ref.watch(userServiceProvider).value?.id
              ? <Widget>[
                  IconButton(
                    iconSize: 32,
                    splashRadius: 24,
                    onPressed: () =>
                        Navigator.of(context).pushNamed(RecipeCreationScreen.routeName, arguments: widget.recipe),
                    icon: const ImageIcon(SpiceSquadIconImages.edit),
                  )
                ]
              : null,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TagItem(image: SpiceSquadIconImages.person, name: widget.recipe.author.userName),
                    const SizedBox(width: 8),
                    TagItem(
                      image: SpiceSquadIconImages.calendar,
                      name:
                          "${widget.recipe.uploadDate.day}.${widget.recipe.uploadDate.month}.${widget.recipe.uploadDate.year}",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  color: Theme.of(context).colorScheme.onSurface,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget.recipe.image != null
                        ? Image.memory(
                            widget.recipe.image!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: ImageIcon(SpiceSquadIconImages.image, size: 48),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LabelList(recipe: widget.recipe),
              const SizedBox(height: 16),
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
                      initialValue: widget.recipe.defaultPortionAmount,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      return FavouriteButton(
                        value: isFavourite,
                        onToggle: () {
                          ref.read(recipeServiceProvider.notifier).toggleFavourite(
                                widget.recipe.copyWith(
                                  isFavourite: isFavourite,
                                ),
                              );
                          setState(() {
                            isFavourite = !isFavourite;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.ingredientListHeadline,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              IngredientList(
                ingredients: widget.recipe.ingredients,
                amountFactor: portionAmount / widget.recipe.defaultPortionAmount,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.instructionsHeadline,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Card(
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.recipe.instructions,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
