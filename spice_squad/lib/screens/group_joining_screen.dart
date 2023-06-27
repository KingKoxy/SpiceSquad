import 'package:flutter/material.dart';
import 'package:spice_squad/screens/main_screen/main_screen.dart';
import 'package:spice_squad/screens/qr_scanner_screen.dart';
import 'package:spice_squad/widgets/or_widget.dart';

import 'group_creation_screen.dart';

class GroupJoiningScreen extends StatelessWidget {
  static const routeName = '/group-joining';

  final TextEditingController _groupCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  GroupJoiningScreen({super.key});

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
                  'Squad beitreten',
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
                            hintText: 'Squadkürzel',
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
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          QRScannerScreen.routeName, (route) => false);
                    },
                    child: const Text('Mit QR-Code beitreten'),
                  ),
                ),
                const OrWidget(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(GroupCreationScreen.routeName);
                    },
                    child: const Text('Squad erstellen'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  String? _validateGroupCode(String? groupCode) {
    if (groupCode == null || groupCode.isEmpty) {
      return 'Bitte gib ein Gruppenkürzel ein.';
    }
    return null;
  }

  void _joinGroupByCode(BuildContext context) {
    //TODO: Implement group joining
    Navigator.of(context)
        .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
  }
}
