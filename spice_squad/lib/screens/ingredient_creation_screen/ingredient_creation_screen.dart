import "package:flutter/material.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/screens/ingredient_creation_screen/icon_picker_widget.dart";
import "package:spice_squad/screens/ingredient_creation_screen/ingredient_name_input.dart";

/// Screen to create a new ingredient
class IngredientCreationScreen extends StatelessWidget {
  /// The route name of this screen
  static const routeName = "/ingredient-creation";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _iconIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  /// Creates a new ingredient creation screen
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(height: 52, child: IconPickerWidget(controller: _iconIdController)),
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
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                      // validates all fields
                      if (!_formKey.currentState!.validate()) return;
                      //creates new ingredient and returns it to the previous screen
                      final ingredient = Ingredient(
                        id: "",
                        name: _nameController.text,
                        iconId: _iconIdController.text,
                        amount: double.parse(_amountController.text),
                        unit: _unitController.text,
                      );

                      Navigator.of(context).pop(ingredient);
                    },
                    child: const Text("Hinzufügen"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
