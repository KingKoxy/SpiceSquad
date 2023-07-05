import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

/// A dialog that displays a success message.
class SuccessDialog extends StatelessWidget {
  /// The title of the dialog.
  final String title;

  /// The message to display.
  final String message;

  /// Creates a [SuccessDialog].
  const SuccessDialog({required this.title, required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.okActionButton),
        ),
      ],
    );
  }
}
