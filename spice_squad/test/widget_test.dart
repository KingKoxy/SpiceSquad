// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_test/flutter_test.dart";
import "package:spice_squad/main.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/user.dart";
import "package:spice_squad/screens/recipe_detail_screen/recipe_detail_screen.dart";

void main() {
  testWidgets("Counter increments smoke test", (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SpiceSquad());

    // Verify that our counter starts at 0.
    expect(find.text("0"), findsOneWidget);
    expect(find.text("1"), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text("0"), findsNothing);
    expect(find.text("1"), findsOneWidget);
  });

  testWidgets(
      "Changing the number of portions to change the quantity of ingredients",
      (WidgetTester tester) async {
    final Recipe recipe = Recipe(
      id: "id",
      title: "title",
      author: User(id: "id", userName: "userName"),
      uploadDate: DateTime.now(),
      duration: 2,
      difficulty: Difficulty.medium,
      isVegetarian: false,
      isVegan: false,
      isGlutenFree: false,
      isHalal: false,
      isKosher: false,
      ingredients: [
        Ingredient(
          id: "id",
          name: "name",
          iconId: "iconId",
          amount: 10.0,
          unit: "g",
        )
      ],
      instructions: "instructions",
      defaultPortionAmount: 1,
      isFavourite: false,
      isPrivate: false,
    );

    final portionAmountFieldFinder =
        find.byKey(const ValueKey("portionAmountField"));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale("de", "DE"),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: RecipeDetailScreen(
          recipe: recipe,
        ),
      ),
    );
    expect(find.text("10.00 g"), findsOneWidget);

    await tester.enterText(portionAmountFieldFinder, "2");
    await tester.pump();

    expect(find.text("20.00 g"), findsOneWidget);
  });
}
