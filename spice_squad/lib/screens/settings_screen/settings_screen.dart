import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/providers/service_providers.dart';
import 'package:spice_squad/screens/login_screen.dart';
import 'package:spice_squad/screens/settings_screen/group_list.dart';
import 'package:spice_squad/screens/settings_screen/profile_image_picker.dart';
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
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ref.watch(userServiceProvider).when(
                data: (user) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileImagePicker(profileImage: user!.profileImage),
                      const SizedBox(
                        height: 8,
                      ),
                      TextButton(
                        onPressed: () {
                          _showRenameDialog(
                              context,
                              ref.read(userServiceProvider.notifier),
                              user.userName);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.userName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const ImageIcon(
                              AssetImage("assets/icons/pen2.png"),
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            _showDeletionDialog(context,
                                ref.read(userServiceProvider.notifier));
                          },
                          child: const Text("Konto löschen"))
                    ],
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => const Column(
                      children: [ CircularProgressIndicator()],
                    )),
            const GroupList()
          ],
        ),
      ),
    );
  }
}

void _logout(UserService userService) {
  userService.logout();
}

void _deleteAccount(UserService userService) {
  userService.deleteAccount();
}

void _renameUser(UserService userService, String newName) {
  userService.setUserName(newName);
}

void _showRenameDialog(
    BuildContext context, UserService userService, String oldName) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  controller.text = oldName;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Umbenennen"),
          content: Form(
            key: formKey,
            child: TextFormField(
              decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.onSurfaceVariant),
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Bitte gib einen neuen Namen ein.";
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Abbrechen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Speichern"),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _renameUser(userService, controller.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      });
}

void _showDeletionDialog(BuildContext context, UserService userService) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konto löschen"),
          content: const Text(
              "Bist du dir wirklich sicher? Es gibt danach keinen Weg zurück"),
          actions: <Widget>[
            TextButton(
              child: const Text("Abbrechen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Ich bin mir sicher"),
              onPressed: () {
                _deleteAccount(userService);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName, (route) => false);
              },
            ),
          ],
        );
      });
}
