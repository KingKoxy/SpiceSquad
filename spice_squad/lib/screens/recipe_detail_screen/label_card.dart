import "package:flutter/material.dart";
import "package:spice_squad/screens/recipe_detail_screen/recipe_detail_screen.dart";

class LabelCard extends StatelessWidget {
  final Label label;

  const LabelCard({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              Image.asset(
                label.labelIcon.toString(),
              ),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  label.labelText,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            ],),),);
  }
}
