import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/service_providers.dart';
import 'package:spice_squad/services/user_service.dart';
import 'package:spice_squad/widgets/nav_bar.dart';

class SettingsScreen extends ConsumerWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      bottomNavigationBar: const NavBar(currentIndex: 2),
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(child: Center(child: Text("Einstellungen"))),
            IconButton(
                onPressed: () {
                  _logout(ref.read(userServiceProvider.notifier));
                },
                icon: const ImageIcon(AssetImage("assets/icons/logout.png")))
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(

          ),
        ),
      ),
    );
  }

  void _logout(UserService userService) {
    userService.logout();
  }
  void _deleteAccount(UserService userService) {
    userService.logout();
  }
  void _renameUser(UserService userService, String newName) {
    userService.logout();
  }
}
