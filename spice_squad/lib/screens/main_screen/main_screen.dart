import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/models/recipe.dart';
import 'package:spice_squad/providers/service_providers.dart';
import 'package:spice_squad/screens/main_screen/filter_selection_widget.dart';
import 'package:spice_squad/screens/main_screen/recipe_list.dart';
import 'package:spice_squad/screens/main_screen/sort.dart';
import 'package:spice_squad/screens/main_screen/sort_selection_widget.dart';

import 'filter_category.dart';

class MainScreen extends ConsumerStatefulWidget {
  static const routeName = '/';

  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  List<FilterCategory> _filterCategories = [];
  Sort _selectedSort = Sort();
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const Padding(
        //   padding: EdgeInsets.all(12.0),
        //   child: ImageIcon(AssetImage("assets/icons/search.png")),
        // ),
        title: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                filled: false,
                border: UnderlineInputBorder(),
                hintText: 'Suchen...',
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SortSelectionWidget(
                          onChanged: (value) {
                            setState(() {
                              _selectedSort = value;
                            });
                          },
                          selectedSort: _selectedSort,
                        ),
                        FilterSelectionWidget(
                          onChanged: (value) {
                            setState(() {
                              _filterCategories = value;
                            });
                          },
                          selectedFilters: _filterCategories,
                        )
                      ],
                    ),
                    ref.watch(recipeServiceProvider).when(
                        data: (recipes) => Expanded(
                            child:
                                RecipeList(recipes: _filterRecipes(recipes))),
                        error: (error, stackTrace) => Text(error.toString()),
                        loading: () => const SizedBox(
                            height: 32,
                            width: 32,
                            child: CircularProgressIndicator())),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Recipe> _filterRecipes(List<Recipe> recipes) {
    recipes = recipes
        .where((element) =>
            element.title.toLowerCase().contains(_searchText.toLowerCase()))
        .toList(growable: false);

    for (var filter in _filterCategories) {
      recipes = recipes
          .where((element) => filter.matches(element))
          .toList(growable: false);
    }

    recipes.sort((a, b) =>
        (_selectedSort.ascending ? 1 : -1) *
        _selectedSort.category.compare(a, b));
    return recipes;
  }
}
