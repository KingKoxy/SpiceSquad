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

  /// Whether this screen is shown after the user registered
  final bool _isAfterRegister;

  final TextEditingController _groupNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Creates a new group creation screen
  GroupCreationScreen({required bool isAfterRegister, super.key}) : _isAfterRegister = isAfterRegister;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _isAfterRegister
                ? Positioned(
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
                  )
                : const Positioned(
                    top: 16,
                    left: 32,
                    child: BackButton(),
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
                              key: const Key("group_name_field"),
                              validator: (value) => _validateGroupName(AppLocalizations.of(context)!, value),
                              keyboardType: TextInputType.text,
                              controller: _groupNameController,
                              maxLength: 32,
                              decoration: InputDecoration(
                                counterText: "",
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
                        key: const Key("create_group_button"),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _createGroup(context, ref.read(groupServiceProvider.notifier), _isAfterRegister);
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
                              .pushReplacementNamed(GroupJoiningScreen.routeName, arguments: _isAfterRegister);
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

  String? _validateGroupName(AppLocalizations appLocalizations, String? groupName) {
    if (groupName == null || groupName.isEmpty) {
      return appLocalizations.squadNameEmptyError;
    }
    if (groupName.length > 32) {
      return appLocalizations.groupCodeTooLongError;
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
