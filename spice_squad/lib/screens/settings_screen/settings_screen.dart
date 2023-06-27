import 'package:flutter/material.dart';

import '../../widgets/nav_bar.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: const NavBar(currentIndex: 2),
    );
  }
}
