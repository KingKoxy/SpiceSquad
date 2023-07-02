import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/screens/password_reset_screen.dart";
import "package:spice_squad/screens/register_screen.dart";
import "package:spice_squad/services/user_service.dart";

/// Screen for logging in
class LoginScreen extends ConsumerWidget {
  /// Route name for navigation
  static const routeName = "/login";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Creates a new login screen
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
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
                AppLocalizations.of(context)!.loginHeadline,
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
                        autofillHints: const [AutofillHints.email],
                        validator: (value) => _validateEmail(context, value),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.emailLabel,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        autofillHints: const [AutofillHints.password],
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.passwordLabel,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.noAccountQuestion,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(RegisterScreen.routeName);
                    },
                    child: Text(AppLocalizations.of(context)!.registerLink),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login(context, ref.read(userServiceProvider.notifier));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.loginButton),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(PasswordResetScreen.routeName);
                },
                child: Text(AppLocalizations.of(context)!.forgotPasswordLink),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _login(BuildContext context, UserService userService) {
    userService
        .login(_emailController.text, _passwordController.text)
        .then((value) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
    });
  }

  String? _validateEmail(BuildContext context, String? email) {
    const emailRegex = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    if (email == null || email.isEmpty) {
      return AppLocalizations.of(context)!.emailEmptyError;
    }
    if (!RegExp(emailRegex).hasMatch(email)) {
      return AppLocalizations.of(context)!.emailInvalidError;
    }
    return null;
  }
}
