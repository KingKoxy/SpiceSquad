import 'package:flutter/material.dart';

import '../../widgets/nav_bar.dart';

class RecipeCreationScreen extends StatelessWidget {
  static const routeName = '/recipe-creation';

  const RecipeCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(currentIndex: 0),
    );
  }
}
