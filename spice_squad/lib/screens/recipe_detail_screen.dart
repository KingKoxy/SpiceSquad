import "package:flutter/material.dart";

/// Screen for displaying a recipe's details
class RecipeDetailScreen extends StatefulWidget {
  /// Route name for navigation
  static const routeName = "/recipe-detail";

  /// Creates a new recipe detail screen
  const RecipeDetailScreen({super.key});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
