import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

/// A dialog that displays a message and asks for approval.
class ApprovalDialog extends StatelessWidget {
  /// The title of the dialog.
  final String _title;

  /// The message to display.
  final String _message;

  /// The callback that is called when the user approves.
  final VoidCallback _onApproval;

  /// Creates an [ApprovalDialog].
  const ApprovalDialog({
    required String title,
    required String message,
    required void Function() onApproval,
    super.key,
  })  : _onApproval = onApproval,
        _message = message,
        _title = title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Text(_message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancelButtonLabel),
        ),
        TextButton(
          onPressed: _onApproval,
          child: Text(AppLocalizations.of(context)!.approvalActionButton),
        ),
      ],
    );
  }
}
