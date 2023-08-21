import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:spice_squad/main.dart" as app;
import "package:spice_squad/screens/group_creation_screen.dart";
import "package:spice_squad/screens/group_detail_screen/group_detail_screen.dart";
import "package:spice_squad/screens/group_joining_screen.dart";
import "package:spice_squad/screens/ingredient_creation_screen/ingredient_creation_screen.dart";
import "package:spice_squad/screens/login_screen.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/screens/recipe_creation_screen/recipe_creation_screen.dart";
import "package:spice_squad/screens/register_screen.dart";
import "package:spice_squad/screens/settings_screen/settings_screen.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  final userNameField = find.byKey(const ValueKey("email"));
  final passwordField = find.byKey(const ValueKey("password"));
  final loginButton = find.byKey(const ValueKey("loginButton"));
  final settingsBottom = find.byWidgetPredicate(
    (Widget widget) =>
        widget is Image &&
        widget.image is AssetImage &&
        (widget.image as AssetImage).assetName == "assets/icons/people.png",
  );
  final portionAmountField = find.byKey(
    const ValueKey("portionAmountField"),
  );

  testWidgets("⟨UC10⟩ login and logout", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(userNameField, "henri.becker@student.kit.edu");
    await tester.enterText(passwordField, "Ich%bin?uncool2");
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);
    expect(find.byKey(const ValueKey("navBar")), findsOneWidget);
    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    final logoutButton = find.byKey(const ValueKey("logoutButton"));
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets("⟨UC20⟩ Register and delete account",
      (WidgetTester tester) async {
    //tester.view.physicalSize = const Size(2560,1800);
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    final registerButton = find.byKey(const ValueKey("registerButton"));
    await tester.tap(registerButton);
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);
    final userNameField = find.byKey(const ValueKey("userNameField"));
    expect(userNameField, findsOneWidget);
    final emailField = find.byKey(const ValueKey("emailField"));
    expect(emailField, findsOneWidget);
    final passwordField = find.byKey(const ValueKey("passwordField"));
    expect(passwordField, findsOneWidget);
    final passwordConfirmationField = find.byKey(
      const ValueKey("passwordRepeatField"),
    );
    expect(passwordConfirmationField, findsOneWidget);
    final registerButton2 = find.byType(ElevatedButton, skipOffstage: false);
    expect(registerButton2, findsOneWidget);
    await tester.enterText(userNameField, "Please delete me");
    await tester.enterText(emailField, "fakeEmail@hotmailer.com");
    await tester.enterText(passwordField, "Lol1234!");
    await tester.enterText(passwordConfirmationField, "Lol1234!");
    expect(registerButton2, findsOneWidget);

    //TODO press register button and delete Account
/*
    final scrollableWidget = find.byKey(const ValueKey("registerScroll"));
    await tester.drag(scrollableWidget, const Offset(0, 200));
    await tester.pumpAndSettle();


    await tester.tap(registerButton2);
    await tester.pumpAndSettle();
    expect(find.byType(GroupJoiningScreen), findsOneWidget);
    final skipButton = find.byKey(const ValueKey("skipButton"));
    await tester.tap(skipButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);
    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    final deleteAccountButton =
        find.byKey(const ValueKey("deleteAccountButton"));
    await tester.tap(deleteAccountButton);
    await tester.pumpAndSettle();
    final deleteAccountButton2 = find.text("I am sure");
    await tester.tap(deleteAccountButton2);
    await tester.pumpAndSettle();
    final confirmButton = find.text("OK");
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    */
  });
  testWidgets("⟨UC40⟩ Change username and profile picture",
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(userNameField, "henri.becker@student.kit.edu");
    await tester.enterText(passwordField, "Ich%bin?uncool2");
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);

    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    final changeUsernameButton = find.byKey(const ValueKey("renameUserButton"));
    await tester.tap(changeUsernameButton);
    await tester.pumpAndSettle();

    final usernameField = find.byKey(const ValueKey("usernameField"));
    await tester.enterText(usernameField, "Aldoso");
    final saveButton = find.text("Save");
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text("Aldoso"), findsOneWidget);
  });

  testWidgets("⟨UC50⟩ Create, modify and delete recipe",
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(userNameField, "henri.becker@student.kit.edu");
    await tester.enterText(passwordField, "Ich%bin?uncool2");
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);
    final recipeCreationButton = find.byWidgetPredicate(
      (Widget widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              "assets/icons/create_document.png",
    );
    await tester.tap(recipeCreationButton);
    await tester.pumpAndSettle();
    expect(find.byType(RecipeCreationScreen), findsOneWidget);

    final recipeNameField = find.byKey(const ValueKey("recipeNameField"));
    final veganTag = find.byKey(const ValueKey("veganTag"));
    final recipeDurationField = find.byKey(
      const ValueKey("recipeDurationField"),
    );
    final recipeInstructionsField = find.byKey(
      const ValueKey("recipeInstructionsField"),
    );
    final addButton = find.byWidgetPredicate(
      (Widget widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == "assets/icons/add.png",
    );
    //final addButton = find.byKey(const ValueKey("addButton"));
    //final saveButton = find.byKey(const ValueKey("saveRecipeButton"));

    await tester.enterText(recipeNameField, "TestRecipe");
    await tester.tap(veganTag, warnIfMissed: false);
    await tester.enterText(recipeDurationField, "69");
    await tester.enterText(portionAmountField, "420");
    await tester.enterText(recipeInstructionsField, "TestInstructions");

    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();
    expect(find.byType(IngredientCreationScreen), findsOneWidget);

    final ingredientNameField =
        find.byKey(const ValueKey("ingredientNameInput"));
    final amountField = find.byKey(const ValueKey("amountInput"));
    final unitField = find.byKey(const ValueKey("unitInput"));
    final saveIngredientButton = find.byKey(const ValueKey("saveButton"));

    await tester.enterText(ingredientNameField, "TestIngredient");
    await tester.enterText(amountField, "1");
    await tester.enterText(unitField, "TestUnit");
    await tester.tap(saveIngredientButton);
    await tester.pumpAndSettle();
    expect(find.byType(RecipeCreationScreen), findsOneWidget);
    expect(find.text("TestIngredient"), findsOneWidget);

    //await tester.tap(saveButton);
  });

  testWidgets("⟨UC80⟩ Create group, join group and delete group",
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(userNameField, "henri.becker@student.kit.edu");
    await tester.enterText(passwordField, "Ich%bin?uncool2");
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);

    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    final addGroupButton = find.byKey(const ValueKey("add_group_button"));
    await tester.tap(addGroupButton);
    await tester.pumpAndSettle();
    expect(find.byType(GroupJoiningScreen), findsOneWidget);

    final createSquadButton = find.byKey(const ValueKey("create_squad_button"));
    await tester.tap(createSquadButton);
    await tester.pumpAndSettle();
    expect(find.byType(GroupCreationScreen), findsOneWidget);

    final groupNameField = find.byKey(const ValueKey("group_name_field"));
    await tester.enterText(groupNameField, "TestGroup");
    final createGroupButton = find.byKey(const ValueKey("create_group_button"));
    await tester.tap(createGroupButton);
    await tester.pumpAndSettle();

    final okButton = find.text("OK");
    await tester.tap(okButton);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    //TODO: delete group
    /*
        final scrollableWidget = find.byKey(const ValueKey("settings_list"));
        await tester.drag(scrollableWidget, const Offset(-50, 200));
        await tester.pumpAndSettle();

        final testGroup = find.byKey(const ValueKey("leave_group_button_TestGroup"));
        expect(testGroup, findsWidgets);
        await tester.tap(testGroup); // wirft warnung
        await tester.pumpAndSettle();

        final leaveGroupButton = find.text("I am sure");
        expect(leaveGroupButton, findsWidgets);
        await tester.tap(leaveGroupButton);
        await tester.pumpAndSettle();
        expect(find.byType(SettingsScreen), findsOneWidget);
         */
  });

  testWidgets("⟨UC100⟩ Appoint Administrator", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(userNameField, "henri.becker@student.kit.edu");
    await tester.enterText(passwordField, "Ich%bin?uncool2");
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);

    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    final groupName = find.text("Change Grouped Name");
    await tester.tap(groupName);
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailScreen), findsOneWidget);

    final popUpMenuMakeAdmin =
        find.byKey(const ValueKey("popupMenuButton"), skipOffstage: false);
    expect(popUpMenuMakeAdmin, findsOneWidget);
    await tester.tap(popUpMenuMakeAdmin);
    await tester.pumpAndSettle();

    final appointAdminButton = find.byKey(const ValueKey("makeAdmin"));
    await tester.tap(appointAdminButton);
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailScreen), findsOneWidget);
  });

  testWidgets("⟨UC100⟩ Remove admin status", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(userNameField, "henri.becker@student.kit.edu");
    await tester.enterText(passwordField, "Ich%bin?uncool2");
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);

    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    final groupName = find.text("Change Grouped Name");
    await tester.tap(groupName);
    await tester.pumpAndSettle();

    final popupMenuRemoveAdmin = find.byKey(const ValueKey("popupMenuButton"));
    expect(popupMenuRemoveAdmin, findsOneWidget);
    await tester.tap(popupMenuRemoveAdmin);
    await tester.pumpAndSettle();

    final removeAdminButton =
        find.byKey(const ValueKey("removeAdminStatus"), skipOffstage: false);
    expect(removeAdminButton, findsOneWidget);
    await tester.tap(removeAdminButton);
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailScreen), findsOneWidget);
  });

  testWidgets("⟨UC130⟩ Change group name", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(userNameField, "henri.becker@student.kit.edu");
    await tester.enterText(passwordField, "Ich%bin?uncool2");
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);

    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    final groupName = find.text("Change Grouped Name");
    await tester.tap(groupName);
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailScreen), findsOneWidget);

    final renameGroupButton = find.byKey(const ValueKey("renameGroupButton"));
    await tester.tap(renameGroupButton);
    await tester.pumpAndSettle();

    final saveButton = find.text("Save");
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailScreen), findsOneWidget);
    expect(find.text("Change Grouped Name"), findsOneWidget);
  });
} // main
