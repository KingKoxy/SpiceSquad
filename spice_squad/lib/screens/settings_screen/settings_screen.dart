import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/login_screen.dart";
import "package:spice_squad/screens/settings_screen/group_list.dart";
import "package:spice_squad/screens/settings_screen/own_recipe_list.dart";
import "package:spice_squad/screens/settings_screen/profile_image_picker.dart";
import "package:spice_squad/services/user_service.dart";
import "package:spice_squad/widgets/approval_dialog.dart";
import "package:spice_squad/widgets/input_dialog.dart";
import "package:spice_squad/widgets/nav_bar.dart";
import "package:spice_squad/widgets/success_dialog.dart";

/// Screen for displaying user settings
class SettingsScreen extends ConsumerWidget {
  /// Route name for navigation
  static const routeName = "/settings";

  /// Creates a new settings screen
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      bottomNavigationBar: const NavBar(currentIndex: 2),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _logout(context, ref.read(userServiceProvider.notifier));
            },
            icon: const ImageIcon(SpiceSquadIconImages.leave),
          )
        ],
        title: Text(AppLocalizations.of(context)!.settingsHeadline),
      ),
      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            ref.watch(userServiceProvider).when(
                  data: (user) {
                    if (user == null) {
                      return Container();
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProfileImagePicker(
                          profileImage: user.profileImage,
                          userService: ref.read(userServiceProvider.notifier),
                        ),
                        TextButton(
                          onPressed: () {
                            _renameUser(context, ref.read(userServiceProvider.notifier), user.userName);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: AutoSizeText(
                                  user.userName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const ImageIcon(
                                SpiceSquadIconImages.edit,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteAccount(context, ref.read(userServiceProvider.notifier));
                          },
                          child: Text(AppLocalizations.of(context)!.deleteAccountButton),
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const Column(
                    children: [CircularProgressIndicator()],
                  ),
                ),
            const SizedBox(
              height: 16,
            ),
            const GroupList(),
            const SizedBox(
              height: 16,
            ),
            const OwnRecipeList(),
          ],
        ),
      ),
    );
  }
}

void _logout(BuildContext context, UserService userService) {
  Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
  userService.logout();
}

void _renameUser(BuildContext context, UserService userService, String oldName) {
  showDialog(
    context: context,
    builder: (context) {
      return InputDialog(
        title: AppLocalizations.of(context)!.renameDialogTitle,
        onSave: (value) => userService.setUserName(value),
        initialValue: oldName,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.renameDialogEmptyError;
          }
          if (value.length > 32) {
            return AppLocalizations.of(context)!.userNameTooLongError;
          }
          return null;
        },
      );
    },
  );
}

void _deleteAccount(BuildContext context, UserService userService) {
  showDialog(
    context: context,
    builder: (context) {
      return ApprovalDialog(
        title: AppLocalizations.of(context)!.deleteAccountDialogTitle,
        message: AppLocalizations.of(context)!.deleteAccountDialogDescription,
        onApproval: () {
          Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
          userService.deleteAccount().then((value) {
            showDialog(
              context: context,
              builder: (context) => const SuccessDialog(title: "Konto gelöscht", message: "Dein Konto wurde gelöscht."),
            );
          });
        },
      );
    },
  );
}
