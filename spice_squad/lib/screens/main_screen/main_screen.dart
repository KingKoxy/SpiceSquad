import 'package:flutter/material.dart';
import 'package:spice_squad/models/difficulty.dart';
import 'package:spice_squad/models/ingredient.dart';
import 'package:spice_squad/models/recipe.dart';
import 'package:spice_squad/models/user.dart';
import 'package:spice_squad/screens/main_screen/filter_selection_widget.dart';
import 'package:spice_squad/screens/main_screen/recipe_card.dart';
import 'package:spice_squad/screens/main_screen/sort.dart';
import 'package:spice_squad/screens/main_screen/sort_selection_widget.dart';

import 'filter_category.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<FilterCategory> _filterCategories = List.empty();
  Sort _selectedSort = Sort();
  String _searchText = "";

  final List<Recipe> _allRecipes = List.of({
    Recipe(
      id: "recipeId",
      title: "Lasagne",
      author: User(id: "userId", userName: "Konrad"),
      uploadDate: DateTime.now(),
      duration: 100,
      difficulty: Difficulty.medium,
      isVegetarian: true,
      isVegan: false,
      isGlutenFree: true,
      isPrivate: false,
      isFavourite: true,
      isKosher: false,
      isHalal: true,
      ingredients: [
        Ingredient(
            id: "ingredientId",
            name: "Mehl",
            iconId: "iconId",
            amount: 50,
            unit: "g")
      ],
      instructions: 'Instructions',
      defaultPortionAmount: 4,
    )
  });

  List<Recipe> _filteredRecipes = List.empty();

  @override
  void initState() {
    _filteredRecipes = _allRecipes;
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _runFiltersAndSort();
  }

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
                        SortSelectionWidget(onChanged: (value) {
                          setState(() {
                            _selectedSort = value;
                          });
                        }, selectedSort: _selectedSort,),
                        FilterSelectionWidget(onChanged: (value) {
                          setState(() {
                            _filterCategories = value;
                          });
                        }, selectedFilters: _filterCategories,)
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        reverse: !_selectedSort.ascending,
                        itemCount: _filteredRecipes.length,
                        itemBuilder: (context, index) {
                          return RecipeCard(recipe: _filteredRecipes[index]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _runFiltersAndSort() {
    List<Recipe> recipes = _allRecipes
        .where((element) =>
            element.title.toLowerCase().contains(_searchText.toLowerCase()))
        .toList(growable: false);

    for (var filter in _filterCategories) {
      recipes = recipes
          .where((element) => filter.matches(element))
          .toList(growable: false);
    }

    recipes.sort(_selectedSort.category.compare);
    _filteredRecipes = recipes;
  }
}
