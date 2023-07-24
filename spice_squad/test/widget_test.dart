// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "package:spice_squad/main.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/screens/recipe_detail_screen/ingredient_list.dart";

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

  testWidgets("Increment portions IngredientList", (WidgetTester tester) async {
    final List<Ingredient> ingredients = [
      Ingredient(
        id: "id",
        name: "name",
        iconId: "iconId",
        amount: 10.0,
        unit: "g",
      )
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: IngredientList(
          ingredients: ingredients,
          amountFactor: 1,
        ),
      ),
    );

    expect(find.text("10.00 g"), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: IngredientList(
          ingredients: ingredients,
          amountFactor: 2,
        ),
      ),
    );

    expect(find.text("20.00 g"), findsOneWidget);
  });
}
