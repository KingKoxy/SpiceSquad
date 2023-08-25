import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:spice_squad/main.dart" as app;
import "package:spice_squad/screens/group_creation_screen.dart";
import "package:spice_squad/screens/group_detail_screen/group_detail_screen.dart";
import "package:spice_squad/screens/group_joining_screen.dart";
import "package:spice_squad/screens/login_screen.dart";
import "package:spice_squad/screens/main_screen/filter_selection_dialog.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/screens/main_screen/recipe_card.dart";
import "package:spice_squad/screens/main_screen/sort_selection_dialog.dart";
import "package:spice_squad/screens/recipe_creation_screen/recipe_creation_screen.dart";
import "package:spice_squad/screens/register_screen.dart";
import "package:spice_squad/screens/settings_screen/settings_screen.dart";

//Tests are to be tested individually since it cannot execute all tests correctly when testing via the main method. There are no fixes for this yet.
void main() {
  SharedPreferences.setMockInitialValues({});
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final userNameField = find.byKey(const ValueKey("email"));
  final passwordField = find.byKey(const ValueKey("password"));
  final loginButton = find.byKey(const ValueKey("loginButton"));
  final settingsBottom = find.byWidgetPredicate(
    (Widget widget) =>
        widget is Image &&
        widget.image is AssetImage &&
        (widget.image as AssetImage).assetName == "assets/icons/people.png",
  );
  final homeBottom = find.byWidgetPredicate(
    (Widget widget) =>
        widget is Image &&
        widget.image is AssetImage &&
        (widget.image as AssetImage).assetName == "assets/icons/home.png",
  );
  final portionAmountField = find.byKey(
    const ValueKey("portionAmountField"),
  );

  testWidgets("⟨UC10⟩ login and logout", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    //input login data and redirection to the main view
    await tester.enterText(userNameField, "henri.becker@student.kit.edu");
    await tester.enterText(passwordField, "Ich%bin?uncool2");
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);
    //Switch to the settings view
    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    //Logout and redirection to the login screen
    await tester.tap(find.byKey(const ValueKey("logoutButton")));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets("⟨UC20⟩ Register and delete account",
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    //Switch to the register screen
    await tester.tap(find.byKey(const ValueKey("registerButton")));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);
    //input register data and redirection to the group joining view
    final registerButton = find.byType(ElevatedButton, skipOffstage: false);
    expect(registerButton, findsOneWidget);
    await tester.ensureVisible(registerButton);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey("userNameField")),
      "Please delete me",
    );
    await tester.enterText(
      find.byKey(const ValueKey("emailField")),
      "fakeEmail@hotmailer.com",
    );
    await tester.enterText(
      find.byKey(const ValueKey("passwordField")),
      "Lol1234!",
    );
    await tester.enterText(
      find.byKey(
        const ValueKey("passwordRepeatField"),
      ),
      "Lol1234!",
    );
    expect(registerButton, findsOneWidget);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();
    //skipping the group joining view and redirection to the main view
    expect(find.byType(GroupJoiningScreen), findsOneWidget);
    final skipButton = find.byKey(const ValueKey("skipButton"));
    await tester.tap(skipButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);
    //switch to the settings view
    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    //delete account and redirection to the login screen
    await tester.tap(find.byKey(const ValueKey("deleteAccountButton")));
    await tester.pumpAndSettle();
    //confirmation dialog
    await tester.tap(find.text("I am sure"));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets("⟨UC40⟩ Change username and profile picture",
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    //input login data and redirection to the main view
    await tester.enterText(userNameField, "henri.becker@student.kit.edu");
    await tester.enterText(passwordField, "Ich%bin?uncool2");
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);
    //Switch to the settings view
    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    //Change username
    await tester.tap(find.byKey(const ValueKey("renameUserButton")));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey("usernameField")),
      "ChangeName",
    );
    await tester.tap(find.text("Save"));
    await tester.pumpAndSettle();
    expect(find.text("ChangeName"), findsOneWidget);
    //Change username back
    await tester.tap(find.byKey(const ValueKey("renameUserButton")));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey("usernameField")), "Aldo");
    await tester.tap(find.text("Save"));
    await tester.pumpAndSettle();
    expect(find.text("Aldo"), findsOneWidget);
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

    await tester.enterText(recipeNameField, "TestRecipe");
    await tester.tap(veganTag, warnIfMissed: false);
    await tester.enterText(recipeDurationField, "69");
    await tester.enterText(portionAmountField, "420");
    await tester.enterText(recipeInstructionsField, "TestInstructions");

    expect(addButton, findsOneWidget);
    final scrollableWidget = find.byKey(const ValueKey("recipeCreationScreen"));
    await tester.drag(scrollableWidget, const Offset(0, 200));
    await tester.pumpAndSettle();

    expect(addButton, findsOneWidget);
    final saveButton = find.byKey(const ValueKey("saveRecipeButton"));
    expect(saveButton, findsOneWidget);

    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();

    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);

    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    final createdRecipe = find.text("TestRecipe", skipOffstage: false);
    expect(createdRecipe, findsOneWidget);
    await tester.ensureVisible(createdRecipe);
    await tester.pumpAndSettle();
    expect(createdRecipe, findsOneWidget);

    await tester.tap(createdRecipe);
    await tester.pumpAndSettle();
    expect(find.byType(RecipeCreationScreen), findsOneWidget);

    final recipeNameField2 = find.byKey(const ValueKey("recipeNameField"));
    await tester.enterText(recipeNameField2, "title_changed");

    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    final deleteRecipeButton =
        find.byKey(const ValueKey("removeButton"), skipOffstage: false).last;
    expect(deleteRecipeButton, findsOneWidget);
    await tester.ensureVisible(deleteRecipeButton);
    await tester.pumpAndSettle();
    await tester.tap(deleteRecipeButton);
    await tester.pumpAndSettle();

    final confirmationText = find.text(
      "Are you sure you want to delete your recipe \"title_changed\"?",
      skipOffstage: false,
    );
    expect(confirmationText, findsOneWidget);

    final deleteButton = find.text("I am sure");
    expect(deleteButton, findsOneWidget);
    await tester.tap(deleteButton);
    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  testWidgets("⟨UC60⟩ Search, sort, filter, view and favorite recipe",
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(userNameField, "henri.becker@student.kit.edu");
    await tester.enterText(passwordField, "Ich%bin?uncool2");
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);

    final searchField = find.byKey(const ValueKey("searchField"));
    await tester.enterText(searchField, "TestRecipe");
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey("recipeCard")), findsNothing);

    final clearSearchButton = find.byKey(const ValueKey("clearSearchButton"));
    await tester.tap(clearSearchButton);
    await tester.pumpAndSettle();
    expect(find.byType(RecipeCard), findsWidgets);

    final sortSelectionButton =
        find.byKey(const ValueKey("sortSelectionButton"));
    await tester.tap(sortSelectionButton);
    await tester.pumpAndSettle();
    expect(find.byType(SortSelectionDialog), findsOneWidget);

    final sortDateButton = find.byKey(const ValueKey("Date"));
    await tester.tap(sortDateButton);
    await tester.pumpAndSettle();

    final saveButton = find.byKey(const ValueKey("saveSortButton"));
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final filterSelectionButton =
        find.byKey(const ValueKey("filterSelectionButton"));
    await tester.tap(filterSelectionButton);
    await tester.pumpAndSettle();
    expect(find.byType(FilterSelectionDialog), findsOneWidget);

    final filterMediumButton = find.byKey(const ValueKey("Medium"));
    await tester.tap(filterMediumButton);
    await tester.pumpAndSettle();

    final saveFilterButton = find.byKey(const ValueKey("saveFilterButton"));
    await tester.tap(saveFilterButton);
    await tester.pumpAndSettle();
    expect(find.byType(RecipeCard), findsWidgets);

    final recipeCard =
        find.byKey(const ValueKey("ba8f5987-10fb-4aa2-9695-97a0a9640749"));
    expect(recipeCard, findsOneWidget);
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

    await tester.tap(find.byKey(const ValueKey("add_group_button")));
    await tester.pumpAndSettle();
    expect(find.byType(GroupJoiningScreen), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey("create_squad_button")));
    await tester.pumpAndSettle();
    expect(find.byType(GroupCreationScreen), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey("group_name_field")),
      "TestGroup",
    );
    await tester.tap(find.byKey(const ValueKey("create_group_button")));
    await tester.pumpAndSettle();

    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    await tester.tap(homeBottom);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);
    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    await tester.drag(
      find.byKey(const ValueKey("settings_list")),
      const Offset(-50, 200),
    );
    await tester.pumpAndSettle();

    final testGroup = find.byKey(
      const ValueKey("leave_group_button_TestGroup"),
      skipOffstage: false,
    );
    expect(testGroup, findsWidgets);
    await tester.ensureVisible(testGroup);
    await tester.pumpAndSettle();
    await tester.tap(testGroup);
    await tester.pumpAndSettle();

    final leaveGroupButton = find.text("I am sure");
    expect(leaveGroupButton, findsWidgets);
    await tester.tap(leaveGroupButton);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  testWidgets("⟨UC100⟩ Appoint administrator and remove administrator status",
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

    await tester.tap(find.text("Change Grouped Name"));
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailScreen), findsOneWidget);

    final popUpMenuMakeAdmin =
        find.byKey(const ValueKey("popupMenuButton"), skipOffstage: false);
    expect(popUpMenuMakeAdmin, findsOneWidget);
    await tester.tap(popUpMenuMakeAdmin);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey("makeAdmin")));
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailScreen), findsOneWidget);

    await tester.tap(homeBottom);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);
    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey("logoutButton")));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey("email")),
      "henri.becker@student.kit.edu",
    );
    await tester.enterText(
      find.byKey(const ValueKey("password")),
      "Ich%bin?uncool2",
    );
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);

    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    await tester.tap(find.text("Change Grouped Name"));
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

  testWidgets("⟨UC110⟩ Kick user and ban user", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    final registerButton = find.byKey(const ValueKey("registerButton"));
    await tester.tap(registerButton);
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);
    final userNameField =
        find.byKey(const ValueKey("userNameField"), skipOffstage: false);
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
    await tester.ensureVisible(registerButton2);
    await tester.pumpAndSettle();

    await tester.enterText(userNameField, "Please delete me");
    await tester.enterText(emailField, "fakeEmail@hotmailer.com");
    await tester.enterText(passwordField, "Lol1234!");
    await tester.enterText(passwordConfirmationField, "Lol1234!");
    expect(registerButton2, findsOneWidget);
    await tester.tap(registerButton2);
    await tester.pumpAndSettle();

    //Fake account joins group
    expect(find.byType(GroupJoiningScreen), findsOneWidget);
    final groupCodeField = find.byKey(const ValueKey("groupCodeInput"));
    final joinGroupButton = find.byKey(const ValueKey("join_squad_button"));
    expect(groupCodeField, findsOneWidget);
    await tester.enterText(groupCodeField, "AH4N9LLV");
    expect(joinGroupButton, findsOneWidget);
    await tester.tap(joinGroupButton);
    await tester.pumpAndSettle();

    final okButton = find.text("OK");
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();

    expect(find.byType(MainScreen), findsOneWidget);
    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey("logoutButton")));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    //Admin Account kicks Fake Account
    final emailInputField =
        find.byKey(const ValueKey("email"), skipOffstage: false);
    final password = find.byKey(const ValueKey("password"));
    await tester.enterText(emailInputField, "henri.becker@student.kit.edu");
    await tester.enterText(password, "Ich%bin?uncool2");
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);
    expect(find.byKey(const ValueKey("navBar")), findsOneWidget);
    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    final groupName = find.text("Gruppe zum kicken", skipOffstage: false);
    await tester.ensureVisible(groupName);
    await tester.pumpAndSettle();
    await tester.tap(groupName);
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailScreen), findsOneWidget);

    final popupMenuRemoveAdmin = find.byKey(const ValueKey("popupMenuButton"));
    expect(popupMenuRemoveAdmin, findsOneWidget);
    await tester.tap(popupMenuRemoveAdmin);
    await tester.pumpAndSettle();

    final kickUserButton =
        find.byKey(const ValueKey("kickUser"), skipOffstage: false);
    expect(kickUserButton, findsOneWidget);
    await tester.tap(kickUserButton);
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailScreen), findsOneWidget);

    final banAccount = find.text("I am sure");
    await tester.tap(banAccount);
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailScreen), findsOneWidget);

    await tester.tap(homeBottom);
    await tester.pumpAndSettle();
    expect(find.byType(MainScreen), findsOneWidget);
    await tester.tap(settingsBottom);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    //Admin log out
    final logoutButton = find.byKey(const ValueKey("logoutButton"));
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    //Delete Fake Account
    expect(emailInputField, findsOneWidget);
    await tester.enterText(emailInputField, "fakeEmail@hotmailer.com");
    await tester.enterText(password, "Lol1234!");
    await tester.tap(loginButton);
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
    expect(find.byType(LoginScreen), findsOneWidget);
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

    await tester.tap(find.text("Change Grouped Name"));
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailScreen), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey("renameGroupButton")));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Save"));
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailScreen), findsOneWidget);
    expect(find.text("Change Grouped Name"), findsOneWidget);
  });
} // main
