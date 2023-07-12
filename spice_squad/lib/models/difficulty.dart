import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

/// Enum for the difficulty of a recipe.
///
/// The difficulty is used to determine the difficulty of a recipe.
///
enum Difficulty {
  /// Easy difficulty
  easy,

  /// Medium difficulty
  medium,

  /// Hard difficulty
  hard;

  /// Returns the string representation of the difficulty.
  String getName(BuildContext context) {
    switch (this) {
      case Difficulty.easy:
        return AppLocalizations.of(context)!.easyDifficulty;
      case Difficulty.medium:
        return AppLocalizations.of(context)!.mediumDifficulty;
      case Difficulty.hard:
        return AppLocalizations.of(context)!.hardDifficulty;
    }
  }
}
