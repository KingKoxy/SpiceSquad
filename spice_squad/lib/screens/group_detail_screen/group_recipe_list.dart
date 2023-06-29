import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spice_squad/providers/service_providers.dart';
import 'package:spice_squad/widgets/eye_button.dart';

import '../../models/group_recipe.dart';
import '../../models/recipe.dart';
import '../../services/group_service.dart';

class GroupRecipeList extends ConsumerWidget {
  final List<GroupRecipe> recipes;
  final bool isAdmin;
  final String groupId;

  const GroupRecipeList({required this.groupId, required this.recipes, required this.isAdmin, super.key});

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
              "Rezepte",
              style: Theme.of(context).textTheme.headlineMedium,
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            recipe.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            recipe.author.userName,
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      EyeButton(
                          open: recipe.isCensored,
                          onToggle: () {
                            _toggleCensored(ref.read(groupServiceProvider.notifier), recipe);
                          })
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }

  void _toggleCensored(GroupService groupService, Recipe recipe) {
    groupService.toggleCensoring(recipe, groupId);
  }
}
