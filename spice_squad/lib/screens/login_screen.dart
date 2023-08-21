import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:http/http.dart";
import "package:spice_squad/exceptions/http_status_exception.dart";
import "package:spice_squad/exceptions/invalid_credentials_error.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/screens/password_reset_screen.dart";
import "package:spice_squad/screens/register_screen.dart";
import "package:spice_squad/services/user_service.dart";

/// Screen for logging in
class LoginScreen extends ConsumerStatefulWidget {
  /// Route name for navigation
  static const routeName = "/login";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Creates a new login screen
  LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String? _emailError;
  bool _loading = false;

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
                  key: const Key("loginHeadline"),
                  AppLocalizations.of(context)!.loginHeadline,
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
                          autocorrect: false,
                          key: const Key("email"),
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) => _validateEmail(
                              AppLocalizations.of(context)!, value),
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
                          autocorrect: false,
                          textInputAction: TextInputAction.done,
                          key: const Key("password"),
                          validator: (value) => _validatePassword(
                              AppLocalizations.of(context)!, value),
                          autofillHints: const [AutofillHints.password],
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          controller: widget._passwordController,
                          onFieldSubmitted: (value) {
                            if (!_loading &&
                                widget._formKey.currentState!.validate()) {
                              _login(AppLocalizations.of(context)!,
                                  ref.read(userServiceProvider.notifier));
                            }
                          },
                          decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.passwordLabel,
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
                      key: const Key("registerButton"),
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
                    key: const Key("loginButton"),
                    onPressed: () {
                      if (!_loading &&
                          widget._formKey.currentState!.validate()) {
                        _login(AppLocalizations.of(context)!,
                            ref.read(userServiceProvider.notifier),);
                      }
                    },
                    child: _loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            AppLocalizations.of(context)!.loginButton,

                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  key: const Key("forgotPasswordButton"),
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
      ),
    );
  }

  Future<void> _login(
      AppLocalizations appLocalizations, UserService userService) async {
    setState(() {
      _loading = true;
    });
    await userService
        .login(widget._emailController.text, widget._passwordController.text)
        .then((value) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
    }).catchError((error) {
      debugPrint(error.toString());
      if (error is InvalidCredentialsError) {
        setState(() {
          _emailError = appLocalizations.loginError;
        });
      } else if (error is ClientException ||
          error is HandshakeException ||
          error is SocketException ||
          (error is HttpStatusException && error.statusCode == 502)) {
        setState(() {
          _emailError = appLocalizations.connectionError;
        });
      }
    });
    setState(() {
      _loading = false;
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

  String? _validatePassword(
      AppLocalizations appLocalizations, String? password) {
    if (password == null || password.isEmpty) {
      return appLocalizations.passwordEmptyError;
    }
    return null;
  }
}
