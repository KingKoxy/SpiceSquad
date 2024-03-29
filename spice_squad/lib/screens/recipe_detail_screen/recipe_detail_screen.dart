import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:marquee/marquee.dart";
import "package:spice_squad/exceptions/too_many_reports_exception.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/recipe_creation_screen/recipe_creation_screen.dart";
import "package:spice_squad/screens/recipe_detail_screen/ingredient_list.dart";
import "package:spice_squad/screens/recipe_detail_screen/label_list.dart";
import "package:spice_squad/services/recipe_service.dart";
import "package:spice_squad/widgets/favourite_button.dart";
import "package:spice_squad/widgets/portion_amount_field.dart";
import "package:spice_squad/widgets/success_dialog.dart";
import "package:spice_squad/widgets/tag_item.dart";

/// A screen showing the details of a recipe.
class RecipeDetailScreen extends ConsumerStatefulWidget {
  /// The route name of this screen.
  static const routeName = "/recipe-detail";

  /// The recipe that is displayed on this screen.
  final Recipe _recipe;

  /// Creates a new recipe detail screen.
  const RecipeDetailScreen({required Recipe recipe, super.key}) : _recipe = recipe;

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  late int _portionAmount;
  late bool _isFavourite;

  @override
  void initState() {
    super.initState();
    _portionAmount = widget._recipe.defaultPortionAmount;
    _isFavourite = widget._recipe.isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: LayoutBuilder(
            builder: (context, constraints) =>
                _willTextOverflow(text: widget._recipe.title, maxWidth: constraints.maxWidth)
                    ? SizedBox(
                        height: 32,
                        child: Marquee(
                          text: widget._recipe.title,
                          blankSpace: 20.0,
                          pauseAfterRound: const Duration(seconds: 2),
                        ),
                      )
                    : Text(
                        widget._recipe.title,
                      ),
          ),
          actions: widget._recipe.author.id == ref.watch(userServiceProvider).value?.id
              ? <Widget>[
                  IconButton(
                    iconSize: 32,
                    splashRadius: 24,
                    onPressed: () =>
                        Navigator.of(context).pushNamed(RecipeCreationScreen.routeName, arguments: widget._recipe),
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
                    TagItem(image: SpiceSquadIconImages.person, name: widget._recipe.author.userName),
                    const SizedBox(width: 8),
                    TagItem(
                      image: SpiceSquadIconImages.calendar,
                      name:
                          "${widget._recipe.uploadDate.day}.${widget._recipe.uploadDate.month}.${widget._recipe.uploadDate.year}",
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
                    child: widget._recipe.imageUrl.isNotEmpty
                        ? Image.network(
                            widget._recipe.imageUrl,
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
              LabelList(recipe: widget._recipe),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: PortionAmountField(
                      onChanged: (value) {
                        setState(() {
                          _portionAmount = value;
                        });
                      },
                      initialValue: widget._recipe.defaultPortionAmount,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      return FavouriteButton(
                        value: _isFavourite,
                        onToggle: () {
                          ref.read(recipeServiceProvider.notifier).toggleFavourite(
                                widget._recipe.copyWith(
                                  isFavourite: _isFavourite,
                                ),
                              );
                          setState(() {
                            _isFavourite = !_isFavourite;
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
                ingredients: widget._recipe.ingredients,
                amountFactor: _portionAmount / widget._recipe.defaultPortionAmount,
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
                      widget._recipe.instructions,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => reportRecipe(ref.read(recipeServiceProvider.notifier)),
                    child: Text(AppLocalizations.of(context)!.reportRecipeButton),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> reportRecipe(RecipeService recipeService) async {
    recipeService
        .reportRecipe(widget._recipe.id)
        .then(
          (value) => showDialog(
            context: context,
            builder: (context) => SuccessDialog(
              title: AppLocalizations.of(context)!.reportSuccessTitle,
              message: AppLocalizations.of(context)!.reportSuccessMessage,
            ),
          ),
        )
        .catchError((error, stackTrace) {
      if (error is TooManyReportsException) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.tooManyReportsErrorTitle),
            content: Text(AppLocalizations.of(context)!.tooManyReportsErrorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.okActionButton),
              )
            ],
          ),
        );
      }
    });
  }

  bool _willTextOverflow({required String text, required double maxWidth}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }
}
