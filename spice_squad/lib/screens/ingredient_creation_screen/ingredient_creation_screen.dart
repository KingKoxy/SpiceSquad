import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spice_squad/screens/ingredient_creation_screen/icon_picker_widget.dart';
import 'package:spice_squad/screens/ingredient_creation_screen/ingredient_name_input.dart';
import 'package:spice_squad/widgets/back_button.dart';

class IngredientCreationScreen extends StatelessWidget {
  static const routeName = '/ingredient-creation';

  const IngredientCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: const Text("Zutat erstellen"),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            IngredientNameInput(),
            const SizedBox(height: 16),
             Row(
              children: [
                const Expanded(child: IconPickerWidget()),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(hintText: "Menge"),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: "Einheit"),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
