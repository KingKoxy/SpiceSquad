import 'package:flutter/cupertino.dart';
import 'package:spice_squad/screens/recipe_detail_screen/recipe_detail_screen.dart';

import 'label_card.dart';

class LabelList extends StatelessWidget {
  final List<Label> labels;

  const LabelList({super.key, required this.labels});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: labels.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LabelCard(label: labels[index]),
            );
          },
        ));
  }
}
