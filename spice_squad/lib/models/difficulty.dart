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

  @override
  String toString() {
    switch (this) {
      case Difficulty.easy:
        return "Einfach";
      case Difficulty.medium:
        return "Mittel";
      case Difficulty.hard:
        return "Schwer";
    }
  }
}
