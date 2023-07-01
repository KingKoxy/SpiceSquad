import "package:flutter/material.dart";
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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            //TODO: conditionally show skip or not
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
                      "Squad erstellen",
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
                              validator: _validateGroupName,
                              keyboardType: TextInputType.text,
                              controller: _groupNameController,
                              decoration: const InputDecoration(
                                hintText: "Squadname",
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
                            _createGroup(context, ref.read(groupServiceProvider.notifier));
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
                          Navigator.of(context).pushReplacementNamed(GroupJoiningScreen.routeName);
                        },
                        child: const Text("Squad beitreten"),
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

  String? _validateGroupName(String? groupCode) {
    if (groupCode == null || groupCode.isEmpty) {
      return "Bitte gib einen Squadnamen ein.";
    }
    return null;
  }

  void _createGroup(BuildContext context, GroupService groupService) {
    groupService
        .createGroup(_groupNameController.text)
        .then(
          (value) => showDialog(
            context: context,
            builder: (context) => const SuccessDialog(
              message: "Die Squad wurde erfolgreich erstellt",
              title: "Squad erstellt",
            ),
          ),
        )
        .then((value) => Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false));
  }
}
