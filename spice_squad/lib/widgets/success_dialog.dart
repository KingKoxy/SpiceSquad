import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

/// A dialog that displays a success message.
class SuccessDialog extends StatelessWidget {
  /// The title of the dialog.
  final String _title;

  /// The message to display.
  final String _message;

  /// Creates a [SuccessDialog].
  const SuccessDialog({required String title, required String message, super.key})
      : _message = message,
        _title = title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Text(_message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.okActionButton),
        ),
      ],
    );
  }
}
