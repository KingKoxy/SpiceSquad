import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/group_joining_screen.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/services/group_service.dart";
import "package:spice_squad/widgets/or_widget.dart";
import "package:spice_squad/widgets/success_dialog.dart";

/// Screen for creating a new group
class GroupCreationScreen extends ConsumerWidget {
  /// Route name for navigation
  static const routeName = "/group-creation";

  final TextEditingController _groupNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Creates a new group creation screen
  GroupCreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get if screen is shown after registering
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    final bool isAfterRegister = args != null && (args as bool);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (isAfterRegister)
              Positioned(
                top: 16,
                right: 32,
                child: Hero(
                  tag: "skip-button",
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
                    },
                    child: Text(AppLocalizations.of(context)!.skipButton),
                  ),
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.createSquadHeadline,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              validator: (value) => _validateGroupName(context, value),
                              keyboardType: TextInputType.text,
                              controller: _groupNameController,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.squadNameInputLabel,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _createGroup(context, ref.read(groupServiceProvider.notifier), isAfterRegister);
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.createSquadButton),
                      ),
                    ),
                    const OrWidget(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(GroupJoiningScreen.routeName, arguments: isAfterRegister);
                        },
                        child: Text(AppLocalizations.of(context)!.joinSquadButton),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateGroupName(BuildContext context, String? groupCode) {
    if (groupCode == null || groupCode.isEmpty) {
      return AppLocalizations.of(context)!.squadNameEmptyError;
    }
    return null;
  }

  void _createGroup(BuildContext context, GroupService groupService, bool isAfterRegister) {
    groupService
        .createGroup(_groupNameController.text)
        .then(
          (value) => showDialog(
            context: context,
            builder: (context) => SuccessDialog(
              title: AppLocalizations.of(context)!.squadCreationSuccessFullTitle,
              message: AppLocalizations.of(context)!.squadCreationSuccessFullDescription,
            ),
          ),
        )
        .then(
          (value) => isAfterRegister
              ? Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false)
              : Navigator.of(context).pop(),
        );
  }
}
