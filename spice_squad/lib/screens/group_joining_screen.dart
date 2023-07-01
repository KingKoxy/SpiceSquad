import "package:flutter/material.dart";
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

  final TextEditingController _groupCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Creates a new group joining screen
  GroupJoiningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (true)
              Positioned(
                top: 16,
                right: 32,
                child: Hero(
                  tag: "skip-button",
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
                    },
                    child: const Text("Überspringen"),
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
                      "Squad beitreten",
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
                              validator: _validateGroupCode,
                              keyboardType: TextInputType.text,
                              controller: _groupCodeController,
                              decoration: const InputDecoration(
                                hintText: "Squadkürzel",
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
                                context, ref.read(groupServiceProvider.notifier), _groupCodeController.text);
                          }
                        },
                        child: const Text("Weiter"),
                      ),
                    ),
                    const OrWidget(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(QRScannerScreen.routeName).then((value) {
                            if (value != null) {
                              _joinGroupByCode(context, ref.read(groupServiceProvider.notifier), value as String);
                            }
                          });
                        },
                        child: const Text("Mit QR-Code beitreten"),
                      ),
                    ),
                    const OrWidget(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(GroupCreationScreen.routeName);
                        },
                        child: const Text("Squad erstellen"),
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

  String? _validateGroupCode(String? groupCode) {
    if (groupCode == null || groupCode.isEmpty) {
      return "Bitte gib ein Gruppenkürzel ein.";
    }
    return null;
  }

  void _joinGroupByCode(BuildContext context, GroupService groupService, String groupCode) {
    groupService
        .joinGroup(groupCode)
        .then(
          (value) => showDialog(
            context: context,
            builder: (context) =>
                const SuccessDialog(message: "Du bist einer Squad beigetreten", title: "Beitritt erfolgreich"),
          ),
        )
        .then((value) => Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false));
  }
}
