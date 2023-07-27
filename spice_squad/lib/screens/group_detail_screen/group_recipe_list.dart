import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/group_recipe.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/recipe_creation_screen/recipe_creation_screen.dart";
import "package:spice_squad/services/group_service.dart";
import "package:spice_squad/widgets/eye_button.dart";

/// Widget to display a list of [GroupRecipe]s
class GroupRecipeList extends ConsumerWidget {
  /// The list of [GroupRecipe]s to display
  final List<GroupRecipe> recipes;

  /// Whether or not the user is admin and can censor recipes
  final bool isAdmin;

  /// The id of the group the recipes belong to
  final String groupId;

  /// A callback to refetch the recipes
  final VoidCallback refetch;

  /// Creates a [GroupRecipeList]
  const GroupRecipeList({
    required this.groupId,
    required this.recipes,
    required this.isAdmin,
    required this.refetch,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    recipes.sort((a, b) {
      if (!a.isCensored && b.isCensored) return 1;
      if (a.isCensored && !b.isCensored) return -1;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.recipeListHeadline,
              style: Theme.of(context).textTheme.headlineMedium,
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: recipes.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return InkWell(
                        borderRadius: BorderRadius.circular(16),
                    onTap: () {
                    Navigator.of(context).pushNamed(
                    RecipeCreationScreen.routeName,
                    arguments: recipe,
                    );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(
                                  recipe.title,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  recipe.author.userName,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          if (isAdmin)
                            EyeButton(
                              open: !recipe.isCensored,
                              onToggle: () {
                                _toggleCensored(
                                  ref.read(groupServiceProvider.notifier),
                                  recipe,
                                );
                              },
                            )
                        ],
                      ),),
                    );
                  },
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context)!.noRecipesFound,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                  ),
                ),
        ),
      ],
    );
  }

  void _toggleCensored(GroupService groupService, GroupRecipe recipe) {
    groupService.toggleCensoring(recipe, groupId).then((value) => refetch());
  }
}
