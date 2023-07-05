import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

/// A dialog that gives the user the possibility to enter a text and save it.
class InputDialog extends StatelessWidget {
  /// The title of the dialog.
  final String title;

  /// The callback that is called when the user saves the input.
  final ValueChanged<String> onSave;

  /// The validator for the input.
  final String? Function(String?)? validator;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  /// Creates an [InputDialog].
  InputDialog({required this.title, required this.onSave, super.key, this.validator, initialValue}) {
    _controller.text = initialValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(fillColor: Theme.of(context).colorScheme.onSurfaceVariant),
          controller: _controller,
          validator: validator,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.cancelButtonLabel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.saveButtonLabel),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop();
              onSave(_controller.text);
            }
          },
        ),
      ],
    );
  }
}
