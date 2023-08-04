import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

/// A dialog that gives the user the possibility to enter a text and save it.
class InputDialog extends StatelessWidget {
  /// The title of the dialog.
  final String _title;

  /// The callback that is called when the user saves the input.
  final ValueChanged<String> _onSave;

  /// The validator for the input.
  final String? Function(String?)? _validator;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  /// Creates an [InputDialog].
  InputDialog({
    required String title,
    required void Function(String) onSave,
    super.key,
    String? Function(String?)? validator,
    initialValue,
  })  : _validator = validator,
        _onSave = onSave,
        _title = title {
    _controller.text = initialValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(fillColor: Theme.of(context).colorScheme.onSurfaceVariant),
          controller: _controller,
          validator: _validator,
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
              _onSave(_controller.text);
            }
          },
        ),
      ],
    );
  }
}
