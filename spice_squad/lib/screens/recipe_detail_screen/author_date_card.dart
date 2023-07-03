import 'package:flutter/material.dart';
import 'package:spice_squad/models/recipe.dart';
import 'package:spice_squad/screens/recipe_detail_screen/label_card.dart';
import 'package:spice_squad/screens/recipe_detail_screen/recipe_detail_screen.dart';

class AuthorDateCard extends StatelessWidget {
  final Recipe recipe;

  const AuthorDateCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        children: [
          LabelCard(label: Label(recipe.author.userName, "assets/icons/user.png")),
          LabelCard(label: Label("${recipe.uploadDate.day.toString()}.${recipe.uploadDate.month.toString()}.${recipe.uploadDate.year.toString()}", "assets/icons/calendar.png")),
        ],
      ),
    );
  }
}
