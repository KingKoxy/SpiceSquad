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

  /// The initial ingredient to edit if this screen is used to edit an ingredient
  final Ingredient? _initialIngredient;

  /// Creates a new ingredient creation screen
  IngredientCreationScreen({super.key, Ingredient? initialIngredient}) : _initialIngredient = initialIngredient {
    if (_initialIngredient != null) {
      _nameController.text = _initialIngredient!.name;
      _amountController.text = _initialIngredient!.amount.toString();
      _unitController.text = _initialIngredient!.unit;
    }
  }

  @override
  State<IngredientCreationScreen> createState() => _IngredientCreationScreenState();
}

class _IngredientCreationScreenState extends State<IngredientCreationScreen> {
  late String _iconUrl;

  @override
  void initState() {
    _iconUrl = widget._initialIngredient?.iconUrl ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Building ingredient creation screen");
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.ingredientCreationHeadline),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                          initialIconUrl: widget._initialIngredient?.iconUrl ?? "",
                          onChanged: (value) {
                            setState(() {
                              _iconUrl = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        key: const Key("amountInput"),
                        validator: (value) {
                          if (value == null || value.isEmpty || double.tryParse(value) == null) {
                            return AppLocalizations.of(context)!.valueNotANumberError;
                          }

                          return null;
                        },
                        controller: widget._amountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"^(0|([1-9]\d?\d?))(\.\d?[1-9]?)?")),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(hintText: AppLocalizations.of(context)!.amountInputLabel),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        key: const Key("unitInput"),
                        validator: (value) {
                          if (value != null && value.length > 16) {
                            return AppLocalizations.of(context)!.unitTooLongError;
                          }
                          return null;
                        },
                        controller: widget._unitController,
                        decoration: InputDecoration(hintText: AppLocalizations.of(context)!.unitInputLabel),
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
                    key: const Key("saveButton"),
                    onPressed: () {
                      // validates all fields
                      if (_iconUrl.isNotEmpty && !widget._formKey.currentState!.validate()) return;
                      //creates new ingredient and returns it to the previous screen
                      final ingredient = Ingredient(
                        id: widget._initialIngredient?.id ?? "",
                        name: widget._nameController.text,
                        amount: double.parse(widget._amountController.text),
                        unit: widget._unitController.text,
                        iconUrl: _iconUrl,
                      );

                      Navigator.of(context).pop(ingredient);
                    },
                    child: Text(AppLocalizations.of(context)!.saveButtonLabel),
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
