import 'package:flutter/material.dart';

class PasswordResetScreen extends StatelessWidget {
  static const routeName = '/password-reset';

  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const Positioned(
          top: 32,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 240,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Passwort vergessen?',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Kein Problem! Gib einfach deine E-Mail-Adresse ein und wir schicken dir einen Link, mit dem du dein Passwort zurücksetzen kannst.",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Colors.grey[600]),
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
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'E-Mail',
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
                      if (_formKey.currentState!.validate()) _sendLink(context);
                    },
                    child: const Text('Weiter'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  String? _validateEmail(String? email) {
    const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (email == null || email.isEmpty) {
      return 'Bitte gib eine E-Mail-Adresse ein';
    }
    if (!RegExp(emailRegex).hasMatch(email)) {
      return 'Bitte gib eine gültige E-Mail-Adresse ein';
    }
    return null;
  }

  _sendLink(BuildContext context) {
    //Show popup with success message an goto login when ok is pressed
  }
}
