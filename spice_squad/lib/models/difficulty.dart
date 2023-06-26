enum Difficulty {
  easy,
  medium,
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
