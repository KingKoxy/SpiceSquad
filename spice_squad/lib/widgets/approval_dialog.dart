import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

/// A dialog that displays a message and asks for approval.
class ApprovalDialog extends StatelessWidget {
  /// The title of the dialog.
  final String title;

  /// The message to display.
  final String message;

  /// The callback that is called when the user approves.
  final VoidCallback onApproval;

  /// Creates an [ApprovalDialog].
  const ApprovalDialog({
    required this.title,
    required this.message,
    required this.onApproval,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancelButtonLabel),
        ),
        TextButton(
          onPressed: onApproval,
          child: Text(AppLocalizations.of(context)!.approvalActionButton),
        ),
      ],
    );
  }
}
