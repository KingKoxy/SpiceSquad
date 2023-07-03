import '../../models/recipe.dart';

class Label {
  String labelText;
  String labelIcon;

  Label(this.labelText,
      this.labelIcon,);
}

List<Label> createLabels(Recipe recipe) {
  List<Label> labels = [
    Label("${recipe.duration} min", "assets/icons/clock.png"),
    Label(recipe.difficulty.toString(), "assets/icons/flame.png")
  ];
  if (recipe.isVegetarian) {
    labels.add(Label("Vegetarisch", "assets/icons/vegetarian.png"));
  } else if (recipe.isVegan) {
    labels.add(Label("Vegan", "assets/icons/vegan.png"));
  }
  if (recipe.isGlutenFree) {
    labels.add(Label("Glutenfrei", "assets/icons/gluten_free.png"));
  }
  if (recipe.isHalal) {
    labels.add(Label("Halal", "assets/icons/halal.png"));
  }
  if (recipe.isKosher) {
    labels.add(Label("Koscher", "assets/icons/koscher.png"));
  }
  return labels;
}