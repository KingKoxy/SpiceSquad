import "dart:typed_data";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/screens/ingredient_creation_screen/icon_picker_widget.dart";
import "package:spice_squad/screens/ingredient_creation_screen/ingredient_name_input.dart";

/// Screen to create a new ingredient
class IngredientCreationScreen extends StatefulWidget {
  /// The route name of this screen
  static const routeName = "/ingredient-creation";
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  final TextEditingController _unitController = TextEditingController();

  /// Creates a new ingredient creation screen
  IngredientCreationScreen({super.key});

  @override
  State<IngredientCreationScreen> createState() => _IngredientCreationScreenState();
}

class _IngredientCreationScreenState extends State<IngredientCreationScreen> {
  Uint8List? _icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.ingredientCreationHeadline),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: widget._formKey,
            child: Column(
              children: [
                IngredientNameInput(
                  controller: widget._nameController,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: IconPickerWidget(
                          onChanged: (icon) {
                            setState(() {
                              _icon = icon;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty || double.tryParse(value) == null) {
                            return AppLocalizations.of(context)!.valueNotANumberError;
                          }

                          return null;
                        },
                        controller: widget._amountController,
                        onChanged: (value) {
                          if (int.tryParse(value) == null) {
                            widget._amountController.text = "";
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[1-9]\d*")),
                        ],
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(counterText: "", hintText: AppLocalizations.of(context)!.amountInputLabel),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.unitEmptyError;
                          }
                          return null;
                        },
                        maxLength: 16,
                        controller: widget._unitController,
                        decoration:
                            InputDecoration(hintText: AppLocalizations.of(context)!.unitInputLabel, counterText: ""),
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
                      if (_icon != null && !widget._formKey.currentState!.validate()) return;
                      //creates new ingredient and returns it to the previous screen
                      final ingredient = Ingredient(
                        id: "",
                        name: widget._nameController.text,
                        amount: int.parse(widget._amountController.text),
                        unit: widget._unitController.text,
                        icon: _icon!,
                      );

                      Navigator.of(context).pop(ingredient);
                    },
                    child: Text(AppLocalizations.of(context)!.addButton),
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
