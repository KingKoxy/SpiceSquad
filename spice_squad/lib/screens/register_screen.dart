import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/group_joining_screen.dart";
import "package:spice_squad/screens/login_screen.dart";
import "package:spice_squad/services/user_service.dart";

/// Screen for registering a new user.
class RegisterScreen extends ConsumerStatefulWidget {
  /// Route name for navigation
  static const routeName = "/register";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Creates a new register screen
  RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  String? _emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                  AppLocalizations.of(context)!.registerHeadline,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: widget._formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          autofillHints: const [AutofillHints.newUsername],
                          validator: (value) => _validateUserName(context, value),
                          keyboardType: TextInputType.name,
                          controller: widget._userNameController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.userNameLabel,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          autofillHints: const [AutofillHints.email],
                          validator: (value) => _validateEmail(context, value),
                          keyboardType: TextInputType.emailAddress,
                          controller: widget._emailController,
                          decoration: InputDecoration(
                            errorText: _emailError,
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
                          autofillHints: const [AutofillHints.newPassword],
                          validator: (value) => _validatePassword(context, value),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          controller: widget._passwordController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.passwordLabel,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          controller: widget._passwordRepeatController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.passwordRepeatLabel,
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
                      AppLocalizations.of(context)!.hasAccountQuestion,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                      },
                      child: Text(AppLocalizations.of(context)!.loginLink),
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
                      if (widget._formKey.currentState!.validate()) {
                        _register(
                          context,
                          ref.read(userServiceProvider.notifier),
                        );
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.registerButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _register(BuildContext context, UserService userService) {
    userService
        .register(
      widget._emailController.text,
      widget._passwordController.text,
      widget._userNameController.text,
    )
        .then((value) {
      debugPrint("Registered user");
      Navigator.of(context).pushNamedAndRemoveUntil(
        GroupJoiningScreen.routeName,
        (route) => false,
        arguments: true,
      );
    }).catchError((error) {
      if (error is ArgumentError && error.message == "EMAIL_ALREADY_IN_USE") {
        setState(() {
          _emailError = AppLocalizations.of(context)!.emailExistsError;
        });
        return;
      }
    });
  }

  String? _validateEmail(BuildContext context, String? email) {
    setState(() {
      _emailError = null;
    });
    const emailRegex = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    if (email == null || email.isEmpty) {
      return AppLocalizations.of(context)!.emailEmptyError;
    }
    if (!RegExp(emailRegex).hasMatch(email)) {
      return AppLocalizations.of(context)!.emailInvalidError;
    }
    return null;
  }

  String? _validateUserName(BuildContext context, String? userName) {
    if (userName == null || userName.isEmpty) {
      return AppLocalizations.of(context)!.userNameEmptyError;
    }
    return null;
  }

  String? _validatePassword(BuildContext context, String? password) {
    if (password == null || password.isEmpty) {
      return AppLocalizations.of(context)!.passwordEmptyError;
    }
    if (password.length < 8) {
      return AppLocalizations.of(context)!.passwordTooShortError;
    }
    if (!RegExp(r"[A-Z]").hasMatch(password)) {
      return AppLocalizations.of(context)!.passwordNeedsUppercaseError;
    }
    if (!RegExp(r"[a-z]").hasMatch(password)) {
      return AppLocalizations.of(context)!.passwordNeedsLowercaseError;
    }
    if (!RegExp(r"\d").hasMatch(password)) {
      return AppLocalizations.of(context)!.passwordNeedsNumberError;
    }
    if (password != widget._passwordRepeatController.text) {
      return AppLocalizations.of(context)!.passwordsDontMatchError;
    }
    return null;
  }
}
