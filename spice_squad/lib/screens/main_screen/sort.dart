import 'package:spice_squad/screens/main_screen/sort_category.dart';

class Sort {
  final bool ascending;
  final SortCategory category;

  Sort({this.ascending = true, this.category = SortCategory.title});
}
