import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/group_recipe.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/recipe_detail_screen/recipe_detail_screen.dart";
import "package:spice_squad/services/group_service.dart";
import "package:spice_squad/widgets/eye_button.dart";

/// Widget to display a list of [GroupRecipe]s
class GroupRecipeList extends ConsumerWidget {
  /// The list of [GroupRecipe]s to display
  final List<GroupRecipe> _recipes;

  /// Whether or not the user is admin and can censor recipes
  final bool _isAdmin;

  /// The id of the group the recipes belong to
  final String _groupId;

  /// A callback to refetch the recipes
  final VoidCallback _refetch;

  /// Creates a [GroupRecipeList]
  const GroupRecipeList({
    required String groupId,
    required List<GroupRecipe> recipes,
    required bool isAdmin,
    required void Function() refetch,
    super.key,
  })  : _refetch = refetch,
        _groupId = groupId,
        _isAdmin = isAdmin,
        _recipes = recipes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _recipes.sort((a, b) {
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
          child: _recipes.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _recipes[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          RecipeDetailScreen.routeName,
                          arguments: recipe,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 8),
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
                            if (_isAdmin)
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
                        ),
                      ),
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
    groupService.toggleCensoring(recipe, _groupId).then((value) => _refetch());
  }
}
