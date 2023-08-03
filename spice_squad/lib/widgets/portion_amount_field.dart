import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

/// A field that is used to select an amount of portions.
class PortionAmountField extends StatelessWidget {
  /// The callback that is called when the amount of portions is changed.
  final ValueChanged<int> _onChanged;

  /// The initial amount of portions.
  final int _initialValue;

  /// Creates a new portion amount field.
  const PortionAmountField({
    required void Function(int) onChanged,
    required int initialValue,
    super.key,
  })  : _initialValue = initialValue,
        _onChanged = onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                key: const Key("portionAmountField"),
                validator: (value) {
                  if (value == null || value.isEmpty) return AppLocalizations.of(context)!.valueNotANumberError;
                  return null;
                },
                style: Theme.of(context).textTheme.titleSmall,
                initialValue: _initialValue.toString(),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[1-9]\d*")),
                ],
                textAlign: TextAlign.center,
                maxLength: 2,
                decoration: const InputDecoration(
                  counterText: "",
                  filled: false,
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) _onChanged(int.parse(value));
                },
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                alignment: Alignment.center,
                color: Theme.of(context).colorScheme.primary,
                child: Text(
                  AppLocalizations.of(context)!.portions,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
