import "package:flutter_gen/gen_l10n/app_localizations.dart";

/// Enum for the difficulty of a recipe.
///
/// The difficulty is used to determine the difficulty of a recipe.
enum Difficulty {
  /// Easy difficulty
  easy,

  /// Medium difficulty
  medium,

  /// Hard difficulty
  hard;

  /// Returns the string representation of the difficulty.
  ///
  /// The appLocalizations are used to get the string representation of the difficulty in different languages.
  String getName(AppLocalizations appLocalizations) {
    switch (this) {
      case Difficulty.easy:
        return appLocalizations.easyDifficulty;
      case Difficulty.medium:
        return appLocalizations.mediumDifficulty;
      case Difficulty.hard:
        return appLocalizations.hardDifficulty;
    }
  }

  /// Returns a difficulty from a [string]. The [string] can be lowercase or uppercase.
  ///
  /// Throws an [ArgumentError] if the [string] is not a valid difficulty.
  static Difficulty fromString(String string) {
    switch (string.toLowerCase()) {
      case "easy":
        return Difficulty.easy;
      case "medium":
        return Difficulty.medium;
      case "hard":
        return Difficulty.hard;
    }
    throw ArgumentError("Invalid difficulty string");
  }
}
