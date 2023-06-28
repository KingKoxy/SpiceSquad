import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/models/recipe.dart';
import 'package:spice_squad/providers/service_providers.dart';
import 'package:spice_squad/screens/main_screen/filter_selection_widget.dart';
import 'package:spice_squad/screens/main_screen/recipe_list.dart';
import 'package:spice_squad/screens/main_screen/sort.dart';
import 'package:spice_squad/screens/main_screen/sort_selection_widget.dart';
import 'package:spice_squad/widgets/nav_bar.dart';

import 'filter_category.dart';

class MainScreen extends ConsumerStatefulWidget {
  static const routeName = '/';
  final _searchController = TextEditingController();

  MainScreen({super.key});

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
      bottomNavigationBar: const NavBar(currentIndex: 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 16),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: widget._searchController,
              decoration: InputDecoration(
                iconColor: Colors.white,
                icon: const ImageIcon(AssetImage("assets/icons/search.png")),
                suffixIconColor: Colors.white,
                suffixIcon: IconButton(onPressed: () {
                  setState(() {
                    _searchText = "";
                    widget._searchController.text = "";
                  });
                }, icon: const Icon(Icons.highlight_remove_rounded)),
                filled: false,
                border: const UnderlineInputBorder(),
                hintText: 'Suchen...',
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
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
                        data: (recipes) =>
                            Expanded(
                                child:
                                RecipeList(recipes: _filterRecipes(recipes))),
                        error: (error, stackTrace) => Text(error.toString()),
                        loading: () =>
                        const SizedBox(
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
