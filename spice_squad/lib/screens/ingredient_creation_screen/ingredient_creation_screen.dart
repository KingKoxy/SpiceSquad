import 'package:flutter/material.dart';
import 'package:spice_squad/screens/ingredient_creation_screen/icon_picker_widget.dart';
import 'package:spice_squad/screens/ingredient_creation_screen/ingredient_name_input.dart';

import '../../models/ingredient.dart';

class IngredientCreationScreen extends StatelessWidget {
  static const routeName = '/ingredient-creation';
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _iconIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  IngredientCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zutat erstellen"),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              IngredientNameInput(
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        height: 52,
                        child: IconPickerWidget(controller: _iconIdController)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Gib bitte einen Wert ein";
                        }

                        if (double.tryParse(value) == null) {
                          return "Gib bitte eine Zahl ein";
                        }

                        return null;
                      },
                      controller: _amountController,
                      onChanged: (value) {
                        if (double.tryParse(value) == null) {
                          _amountController.text = "";
                        }
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(hintText: "Menge"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Gib bitte eine Einheit ein";
                        }
                        return null;
                      },
                      controller: _unitController,
                      decoration: const InputDecoration(hintText: "Einheit"),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      var ingredient = Ingredient(
                        id: '',
                        name: _nameController.text,
                        iconId: _iconIdController.text,
                        amount: double.parse(_amountController.text),
                        unit: _unitController.text,
                      );

                      Navigator.of(context).pop(ingredient);
                    },
                    child: const Text("Hinzufügen")),
              )
            ],
          ),
        ),
      )),
    );
  }
}
