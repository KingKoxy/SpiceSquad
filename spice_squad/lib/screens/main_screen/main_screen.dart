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
  static const routeName = "/main";

  final _searchController = TextEditingController();

  /// Creates a new main screen.
  MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();

  /// Method for testing the filtering of recipes.
  @visibleForTesting
  List<Recipe> filteredRecipesMethode(
    List<Recipe> recipes,
    List<FilterCategory> filterCategories,
  ) {
    return (_MainScreenState().._filterCategories = filterCategories)._filterRecipes(recipes);
  }
}

class _MainScreenState extends ConsumerState<MainScreen> {
  // The different filter and sort options. These are the state of the main screen.
  List<FilterCategory> _filterCategories = [];
  Sort _selectedSort = Sort();
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Remove focus from text field when tapping outside of it.
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: const NavBar(currentIndex: 1),
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, right: 24, left: 24),
                  child: TextField(
                    controller: widget._searchController,
                    decoration: InputDecoration(
                      prefixIconColor: Colors.white,
                      prefixIcon: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                        child: ImageIcon(
                          SpiceSquadIconImages.search,
                          size: 24,
                        ),
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
                      hintText:
                          AppLocalizations.of(context)!.searchInputPlaceholder,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
                // The sort and filter option selectors.
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
                  child: Row(
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
                ),
                //The list of recipes.
                ref.watch(recipeServiceProvider).when(
                      data: (recipes) =>
                          RecipeList(recipes: _filterRecipes(recipes)),
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => const SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Filters and sorts the given list of recipes according to the current filter and sort options.
  List<Recipe> _filterRecipes(List<Recipe> recipes) {
    recipes = recipes
        .where((element) => element.title.toLowerCase().contains(_searchText.toLowerCase()))
        .toList(growable: false);

    for (final filter in _filterCategories) {
      recipes = recipes.where(filter.matches).toList(growable: false);
    }
    recipes.sort((a, b) => (_selectedSort.ascending ? 1 : -1) * _selectedSort.category.compare(a, b));
    return recipes;
  }
}
