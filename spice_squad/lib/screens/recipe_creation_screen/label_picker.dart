import "package:flutter/material.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/screens/recipe_creation_screen/label.dart";
import "package:spice_squad/screens/recipe_creation_screen/label_button.dart";

class LabelPicker extends StatefulWidget {
  final Recipe recipe;
  List<Label> labels;

  LabelPicker({required this.labels, required this.recipe, super.key});

  @override
  State<LabelPicker> createState() => _LabelPickerState();
}

class _LabelPickerState extends State<LabelPicker> {
  late Recipe _recipe;

  @override
  void initState() {
    _recipe = widget.recipe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            LabelButton(
              label: Label("Vegetarisch", "assets/icons/vegetarian.png"),
              value: _recipe.isVegetarian,
              onToggle: () {},
            ),
            LabelButton(
              label: Label("Vegan", "assets/icons/vegan.png"),
              value: _recipe.isVegan,
              onToggle: () {},
            ),
            LabelButton(
              label: Label("Glutenfrei", "assets/icons/gluten_free.png"),
              value: _recipe.isGlutenFree,
              onToggle: () {},
            ),
            LabelButton(
              label: Label("Halal", "assets/icons/halal.png"),
              value: _recipe.isHalal,
              onToggle: () {},
            ),
            LabelButton(
                label: Label("Koscher", "assets/icons/koscher.png"),
                value: _recipe.isKosher,
                onToggle: () {},),
          ],
        ),);
  }
}
