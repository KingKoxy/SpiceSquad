import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/repository_providers.dart';
import 'package:spice_squad/providers/service_providers.dart';
import 'package:spice_squad/screens/recipe_creation_screen/recipe_creation_screen.dart';
import 'package:spice_squad/services/recipe_service.dart';
import 'package:spice_squad/models/recipe.dart';
import 'package:spice_squad/widgets/eye_button.dart';
import 'package:spice_squad/widgets/remove_button.dart';

class OwnRecipeList extends ConsumerWidget {
  const OwnRecipeList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Meine Rezepte",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ref.watch(recipeServiceProvider).when(data: (recipes) {
          final ownRecipes =
              recipes.where((recipe) => recipe.author.id == ref.watch(userRepositoryProvider).getUserId()).toList();
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListView.builder(
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
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            recipe.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                splashRadius: 24,
                                  onPressed: () => _exportRecipe(ref.read(recipeServiceProvider.notifier), recipe),
                                  icon: const ImageIcon(AssetImage("assets/icons/share.png"))),
                              EyeButton(
                                  open: recipe.isPrivate,
                                  onToggle: () => _hideRecipe(ref.read(recipeServiceProvider.notifier), recipe)),
                              RemoveButton(
                                  onPressed: () =>
                                      _deleteRecipe(context, ref.read(recipeServiceProvider.notifier), recipe.id)),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
        }, error: (error, stackTrace) {
          return Text(error.toString());
        }, loading: () {
          return const CircularProgressIndicator();
        })
      ],
    );
  }

  void _hideRecipe(RecipeService recipeService, Recipe recipe) {
    recipeService.togglePrivate(recipe);
  }

  void _exportRecipe(RecipeService recipeService, Recipe recipe) {
    recipeService.exportRecipe(recipe);
  }

  void _deleteRecipe(BuildContext context, RecipeService recipeService, String recipeId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Rezept löschen"),
            content: const Text("Bist du sicher, dass du das Rezept löschen möchtest?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Abbrechen')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    recipeService.deleteRecipe(recipeId);
                  },
                  child: const Text('Ich bin mir sicher'))
            ],
          );
        });
  }
}
