import "package:flutter/cupertino.dart";
import "package:spice_squad/screens/recipe_detail_screen/label_card.dart";
import "package:spice_squad/screens/recipe_detail_screen/recipe_detail_screen.dart";

class LabelList extends StatelessWidget {
  final List<Label> labels;

  const LabelList({required this.labels, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: LabelCard(label: labels[index]),
          );
        },
    );
  }
}
