import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/main_screen/filter_category.dart";
import "package:spice_squad/screens/main_screen/filter_selection_widget.dart";
import "package:spice_squad/screens/main_screen/recipe_list.dart";
import "package:spice_squad/screens/main_screen/sort.dart";
import "package:spice_squad/screens/main_screen/sort_selection_widget.dart";
import "package:spice_squad/widgets/nav_bar.dart";

/// The main screen of the app showing a list of recipes for the user.
class MainScreen extends ConsumerStatefulWidget {
  /// The route name of the main screen.
  static const routeName = "/";

  final _searchController = TextEditingController();

  /// Creates a new main screen.
  MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();

  /// Methode for testing the filtering of recipes.
  @visibleForTesting
  List<Recipe> filteredRecipesMethode(
    List<Recipe> recipes,
    List<FilterCategory> filterCategories,
  ) {
    return (_MainScreenState().._filterCategories = filterCategories)
        ._filterRecipes(recipes);
  }
}

class _MainScreenState extends ConsumerState<MainScreen> {
  // The different filter and sort options. These are the state of the main screen.
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
            // The search field.
            child: TextField(
              controller: widget._searchController,
              decoration: InputDecoration(
                iconColor: Colors.white,
                icon: const ImageIcon(
                  size: 32,
                  SpiceSquadIconImages.search,
                ),
                suffixIconColor: Colors.white,
                suffixIcon: widget._searchController.text != ""
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _searchText = "";
                            widget._searchController.text = "";
                          });
                        },
                        icon: const Icon(Icons.highlight_remove_rounded),
                      )
                    : null,
                filled: false,
                border: const UnderlineInputBorder(),
                hintText: AppLocalizations.of(context)!.searchInputPlaceholder,
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
                    // The sort and filter option selectors.
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
                    //The list of recipes.
                    ref.watch(recipeServiceProvider).when(
                          data: (recipes) =>
                              RecipeList(recipes: _filterRecipes(recipes)),
                          error: (error, stackTrace) => Text(error.toString()),
                          loading: () => const SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator()),
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

  /// Filters and sorts the given list of recipes according to the current filter and sort options.
  List<Recipe> _filterRecipes(List<Recipe> recipes) {
    recipes = recipes
        .where((element) =>
            element.title.toLowerCase().contains(_searchText.toLowerCase()))
        .toList(growable: false);

    for (final filter in _filterCategories) {
      recipes = recipes.where(filter.matches).toList(growable: false);
    }

    recipes.sort((a, b) =>
        (_selectedSort.ascending ? 1 : -1) *
        _selectedSort.category.compare(a, b));
    return recipes;
  }
}
