import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/services/user_service.dart";

/// Screen for resetting the password
class PasswordResetScreen extends ConsumerWidget {
  /// Route name for navigation
  static const routeName = "/password-reset";

  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Creates a new password reset screen
  PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          const Positioned(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: "logo",
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 240,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Passwort vergessen?",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Kein Problem! Gib einfach deine E-Mail-Adresse ein und wir schicken dir einen Link, mit dem du dein Passwort zurücksetzen kannst.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
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
                            autofillHints: const [AutofillHints.email],
                            validator: _validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: "E-Mail",
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
                          _resetPassword(context, ref.read(userServiceProvider.notifier));
                        }
                      },
                      child: const Text("Weiter"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],),
      ),
    );
  }

  String? _validateEmail(String? email) {
    const emailRegex = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    if (email == null || email.isEmpty) {
      return "Bitte gib eine E-Mail-Adresse ein";
    }
    if (!RegExp(emailRegex).hasMatch(email)) {
      return "Bitte gib eine gültige E-Mail-Adresse ein";
    }
    return null;
  }

  _resetPassword(BuildContext context, UserService userService) {
    userService.resetPassword(_emailController.text).then((value) => showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("E-Mail versendet"),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text("Wir haben dir eine E-Mail mit einem Link zum Zurücksetzen deines Passworts geschickt."),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Bestätigen"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ),);
  }
}
