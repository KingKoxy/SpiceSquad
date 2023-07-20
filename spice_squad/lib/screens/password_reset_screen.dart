import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/services/user_service.dart";
import "package:spice_squad/widgets/success_dialog.dart";

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
        child: Stack(
          children: [
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
                      AppLocalizations.of(context)!.resetPasswordHeadline,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.resetPasswordDescription,
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
                              validator: (value) => _validateEmail(context, value),
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.emailLabel,
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
                        child: Text(
                          AppLocalizations.of(context)!.resetPasswordButton,
                        ),
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

  _resetPassword(BuildContext context, UserService userService) {
    userService.resetPassword(_emailController.text).whenComplete(
          () => showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => SuccessDialog(
              title: AppLocalizations.of(context)!.resetPasswordSuccessHeadline,
              message: AppLocalizations.of(context)!.resetPasswordSuccessDescription,
            ),
          ).then((value) => Navigator.of(context).pop()),
        );
  }
}
