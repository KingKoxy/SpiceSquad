import 'package:flutter/material.dart';
import 'package:spice_squad/screens/group_joining_screen.dart';
import 'package:spice_squad/screens/main_screen/main_screen.dart';
import 'package:spice_squad/screens/qr_scanner_screen.dart';
import 'package:spice_squad/widgets/or_widget.dart';

class GroupCreationScreen extends StatelessWidget {
  static const routeName = '/group-creation';

  final TextEditingController _groupNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  GroupCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        if (true)
          Positioned(
            top: 32,
            right: 32,
            child: Hero(
              tag: 'skip-button',
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MainScreen.routeName, (route) => false);
                },
                child: const Text('Überspringen'),
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
                  'Squad erstellen',
                  style: Theme.of(context).textTheme.headline4,
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
                            hintText: 'Squadname',
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
                        _joinGroupByCode(context);
                      }
                    },
                    child: const Text('Weiter'),
                  ),
                ),
                const OrWidget(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(GroupJoiningScreen.routeName);
                    },
                    child: const Text('Squad beitreten'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  String? _validateGroupName(String? groupCode) {
    if (groupCode == null || groupCode.isEmpty) {
      return 'Bitte gib einen Gruppennamen ein.';
    }
    return null;
  }

  void _joinGroupByCode(BuildContext context) {
    //TODO: Implement group creation
    Navigator.of(context)
        .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
  }
}
