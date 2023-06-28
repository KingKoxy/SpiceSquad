import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PortionAmountField extends StatelessWidget {
  final ValueChanged<int> onChanged;
  final int portionAmount;

  const PortionAmountField(
      {super.key, required this.onChanged, required this.portionAmount});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            Expanded(
                child: TextFormField(
              initialValue: portionAmount.toString(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                filled: false,
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) onChanged(int.parse(value));
              },
            )),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                alignment: Alignment.center,
                color: Theme.of(context).colorScheme.primary,
                child: const Text(
                  "Portionen",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
