import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/pdf_recipe_page.dart";
import "package:spice_squad/screens/recipe_creation_screen/recipe_creation_screen.dart";
import "package:spice_squad/services/recipe_service.dart";
import "package:spice_squad/widgets/approval_dialog.dart";
import "package:spice_squad/widgets/eye_button.dart";
import "package:spice_squad/widgets/remove_button.dart";

/// Widget for displaying a list of recipes the user has created
class OwnRecipeList extends ConsumerWidget {
  final String userId;

  /// Creates a new own recipe list
  const OwnRecipeList({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.myRecipeListLabel,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        // Fetch all recipes from database.
        ref.watch(recipeServiceProvider).when(
          data: (recipes) {
            // Filter for own recipes.
            final ownRecipes =
                recipes.where((recipe) => recipe.author.id == userId).toList();
            ownRecipes.sort(
              (Recipe a, Recipe b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
            );
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ownRecipes.isNotEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ownRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = ownRecipes[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.of(context).pushNamed(RecipeCreationScreen.routeName, arguments: recipe);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    recipe.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      iconSize: 24,
                                      splashRadius: 24,
                                      onPressed: () => Navigator.of(context)
                                          .pushNamed(PdfRecipeViewPage.routeName, arguments: recipe),
                                      icon: const ImageIcon(SpiceSquadIconImages.export, size: 24),
                                    ),
                                    EyeButton(
                                      open: !recipe.isPrivate,
                                      onToggle: () => _hideRecipe(ref.read(recipeServiceProvider.notifier), recipe),
                                    ),
                                    RemoveButton(
                                      onPressed: () =>
                                          _deleteRecipe(context, ref.read(recipeServiceProvider.notifier), recipe),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        AppLocalizations.of(context)!.userHasNoRecipes,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                      ),
                    ),
            );
          },
          error: (error, stackTrace) {
            return Text(error.toString());
          },
          loading: () {
            return const CircularProgressIndicator();
          },
        )
      ],
    );
  }

  void _hideRecipe(RecipeService recipeService, Recipe recipe) {
    recipeService.togglePrivate(recipe);
  }

  void _deleteRecipe(BuildContext context, RecipeService recipeService, Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) {
        return ApprovalDialog(
          title: AppLocalizations.of(context)!.deleteRecipeDialogTitle,
          message: AppLocalizations.of(context)!.deleteRecipeDialogDescription(recipe.title),
          onApproval: () {
            Navigator.of(context).pop();
            recipeService.deleteRecipe(recipe.id);
          },
        );
      },
    );
  }
}
