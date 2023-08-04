import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/user.dart";
import "package:spice_squad/screens/main_screen/filter_category.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/screens/recipe_detail_screen/recipe_detail_screen.dart";

final Recipe recipeOne = Recipe(
  id: "1",
  title: "vegan",
  author: User(id: "id", userName: "userName"),
  uploadDate: DateTime.now(),
  duration: 2,
  difficulty: Difficulty.medium,
  isVegetarian: false,
  isVegan: true,
  isGlutenFree: false,
  isHalal: false,
  isKosher: false,
  ingredients: [
    Ingredient(
      id: "id",
      name: "name",
      iconUrl: "https://img.icons8.com/?size=64&id=95280&format=png",
      amount: 10.0,
      unit: "g",
    )
  ],
  instructions: "instructions",
  defaultPortionAmount: 1,
  isFavourite: false,
  isPrivate: false,
);

final Recipe recipeTwo = Recipe(
  id: "2",
  title: "vegan halal kosher medium",
  author: User(id: "id", userName: "user"),
  uploadDate: DateTime.now(),
  duration: 2,
  difficulty: Difficulty.medium,
  isVegetarian: false,
  isVegan: true,
  isGlutenFree: false,
  isHalal: true,
  isKosher: false,
  ingredients: [],
  instructions: "instructions",
  defaultPortionAmount: 1,
  isFavourite: false,
  isPrivate: false,
);

final Recipe recipeThree = Recipe(
  id: "3",
  title: "vegan halal kosher hard",
  author: User(id: "id", userName: "userName"),
  uploadDate: DateTime.now(),
  duration: 2,
  difficulty: Difficulty.hard,
  isVegetarian: false,
  isVegan: true,
  isGlutenFree: false,
  isHalal: true,
  isKosher: true,
  ingredients: [],
  instructions: "instructions",
  defaultPortionAmount: 1,
  isFavourite: false,
  isPrivate: false,
);

void main() {
  testWidgets(
      "Changing the number of portions to change the quantity of ingredients",
      (WidgetTester tester) async {
    final portionAmountFieldFinder =
        find.byKey(const ValueKey("portionAmountField"));

    final container = ProviderContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale("de", "DE"),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: RecipeDetailScreen(
            recipe: recipeOne,
          ),
        ),
      ),
    );
    expect(find.text("10.00 g"), findsOneWidget);

    await tester.enterText(portionAmountFieldFinder, "2");
    await tester.pump();

    expect(find.text("20.00 g"), findsOneWidget);
  });

  test("Filtering the recipes by several categories", () {
    final List<Recipe> recipes = [recipeOne, recipeTwo, recipeThree];
    final List<FilterCategory> filterCategories = [
      FilterCategory.labelVegan,
      FilterCategory.labelHalal,
      FilterCategory.labelKosher,
      FilterCategory.difficultyHard,
    ];
    final List<Recipe> filteredRecipes =
        MainScreen().filteredRecipesMethode(recipes, filterCategories);

    expect(filteredRecipes, [recipeThree]);
  });
}
