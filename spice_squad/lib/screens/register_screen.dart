import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:http/http.dart";
import "package:spice_squad/exceptions/email_already_in_use_error.dart";
import "package:spice_squad/exceptions/http_status_exception.dart";
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
  String? _connectionError;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                          validator: (value) => _validateUserName(AppLocalizations.of(context)!, value),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          controller: widget._userNameController,
                          decoration: InputDecoration(
                            errorText: _connectionError,
                            counterText: "",
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
                          textInputAction: TextInputAction.next,
                          validator: (value) => _validateEmail(AppLocalizations.of(context)!, value),
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
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                          validator: (value) => _validatePassword(AppLocalizations.of(context)!, value),
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
                          autofillHints: const [AutofillHints.newPassword],
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) {
                            if (!loading && widget._formKey.currentState!.validate()) {
                              _register(
                                AppLocalizations.of(context)!,
                                ref.read(userServiceProvider.notifier),
                              );
                            }
                          },
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
                      if (!loading && widget._formKey.currentState!.validate()) {
                        _register(
                          AppLocalizations.of(context)!,
                          ref.read(userServiceProvider.notifier),
                        );
                      }
                    },
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(AppLocalizations.of(context)!.registerButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register(AppLocalizations appLocalizations, UserService userService) async {
    setState(() {
      loading = true;
      _connectionError = null;
    });
    await userService
        .register(
      widget._emailController.text,
      widget._passwordController.text,
      widget._userNameController.text,
    )
        .then((value) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        GroupJoiningScreen.routeName,
        (route) => false,
        arguments: true,
      );
    }).catchError((error) {
      debugPrint(error.toString());
      if (error is EmailAlreadyInUseError) {
        setState(() {
          _emailError = appLocalizations.emailExistsError;
        });
      } else if (error is ClientException ||
          error is HandshakeException ||
          error is SocketException ||
          (error is HttpStatusException && error.statusCode == 502)) {
        setState(() {
          _connectionError = appLocalizations.connectionError;
        });
      }
    });
    setState(() {
      loading = false;
    });
  }

  String? _validateEmail(AppLocalizations appLocalizations, String? email) {
    setState(() {
      _emailError = null;
    });
    const emailRegex = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    if (email == null || email.isEmpty) {
      return appLocalizations.emailEmptyError;
    }
    if (!RegExp(emailRegex).hasMatch(email)) {
      return appLocalizations.emailInvalidError;
    }
    return null;
  }

  String? _validateUserName(AppLocalizations appLocalizations, String? userName) {
    if (userName == null || userName.isEmpty) {
      return appLocalizations.userNameEmptyError;
    }
    if (userName.length > 32) {
      return appLocalizations.userNameTooLongError;
    }
    return null;
  }

  String? _validatePassword(AppLocalizations appLocalizations, String? password) {
    if (password == null || password.isEmpty) {
      return appLocalizations.passwordEmptyError;
    }
    if (password.length < 8) {
      return appLocalizations.passwordTooShortError;
    }
    if (!RegExp(r"[A-Z]").hasMatch(password)) {
      return appLocalizations.passwordNeedsUppercaseError;
    }
    if (!RegExp(r"[a-z]").hasMatch(password)) {
      return appLocalizations.passwordNeedsLowercaseError;
    }
    if (!RegExp(r"\d").hasMatch(password)) {
      return appLocalizations.passwordNeedsNumberError;
    }
    if (password != widget._passwordRepeatController.text) {
      return appLocalizations.passwordsDontMatchError;
    }
    return null;
  }
}
