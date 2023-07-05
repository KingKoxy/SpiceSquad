import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/group_creation_screen.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/screens/qr_scanner_screen.dart";
import "package:spice_squad/services/group_service.dart";
import "package:spice_squad/widgets/or_widget.dart";
import "package:spice_squad/widgets/success_dialog.dart";

/// Screen for joining a group
class GroupJoiningScreen extends ConsumerWidget {
  /// Route name for navigation
  static const routeName = "/group-joining";

  /// Whether this screen is shown after the user registered
  final bool isAfterRegister;

  final TextEditingController _groupCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Creates a new group joining screen
  GroupJoiningScreen({required this.isAfterRegister, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        MainScreen.routeName,
                        (route) => false,
                      );
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
                      AppLocalizations.of(context)!.joinSquadHeadline,
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
                              validator: (value) => _validateGroupCode(context, value),
                              keyboardType: TextInputType.text,
                              controller: _groupCodeController,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.groupCodeInputLabel,
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
                            _joinGroupByCode(
                              context,
                              ref.read(groupServiceProvider.notifier),
                              _groupCodeController.text,
                              isAfterRegister,
                            );
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.joinSquadButton),
                      ),
                    ),
                    const OrWidget(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(QRScannerScreen.routeName).then((value) {
                            if (value != null) {
                              _joinGroupByCode(
                                context,
                                ref.read(groupServiceProvider.notifier),
                                value as String,
                                isAfterRegister,
                              );
                            }
                          });
                        },
                        child: Text(AppLocalizations.of(context)!.joinWithQRCodeButton),
                      ),
                    ),
                    const OrWidget(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                            GroupCreationScreen.routeName,
                            arguments: isAfterRegister,
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.createSquadButton),
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

  String? _validateGroupCode(BuildContext context, String? groupCode) {
    if (groupCode == null || groupCode.isEmpty) {
      return AppLocalizations.of(context)!.groupCodeEmptyError;
    }
    return null;
  }

  void _joinGroupByCode(
    BuildContext context,
    GroupService groupService,
    String groupCode,
    bool isAfterRegister,
  ) {
    groupService
        .joinGroup(groupCode)
        .then(
          (value) =>
          showDialog(
            context: context,
            builder: (context) => SuccessDialog(
              title: AppLocalizations.of(context)!.joiningSuccessFullTitle,
              message: AppLocalizations.of(context)!.joiningSuccessFullDescription,
            ),
          ),
    )
        .then(
          (value) => isAfterRegister
              ? Navigator.of(context).pushNamedAndRemoveUntil(
                  MainScreen.routeName,
                  (route) => false,
                )
              : Navigator.of(context).pop(),
        );
  }
}
