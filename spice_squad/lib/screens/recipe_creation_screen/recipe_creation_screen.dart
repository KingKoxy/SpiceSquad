import "dart:typed_data";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/recipe_creation_data.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/recipe_creation_screen/difficulty_picker_widget.dart";
import "package:spice_squad/screens/recipe_creation_screen/image_picker_widget.dart";
import "package:spice_squad/screens/recipe_creation_screen/ingredient_list.dart";
import "package:spice_squad/screens/recipe_creation_screen/toggleable_label_widget.dart";
import "package:spice_squad/services/recipe_service.dart";
import "package:spice_squad/widgets/nav_bar.dart";
import "package:spice_squad/widgets/portion_amount_field.dart";

/// Screen for creating a new recipe
class RecipeCreationScreen extends StatefulWidget {
  /// Route name for navigation
  static const routeName = "/recipe-creation";

  final _formKey = GlobalKey<FormState>();

  /// The recipe to edit if this screen is used for editing
  final Recipe? recipe;

  /// Creates a new recipe creation screen
  RecipeCreationScreen({required this.recipe, super.key});

  @override
  State<RecipeCreationScreen> createState() => _RecipeCreationScreenState();
}

class _RecipeCreationScreenState extends State<RecipeCreationScreen> {
  late String _title;
  late int _duration;
  late Difficulty _difficulty;
  late bool _isVegetarian;
  late bool _isVegan;
  late bool _isGlutenFree;
  late bool _isHalal;
  late bool _isKosher;
  late List<Ingredient> _ingredients;
  late String _instructions;
  late int _defaultPortionAmount;
  late Uint8List? _image;

  @override
  void initState() {
    _title = widget.recipe?.title ?? "";
    _duration = widget.recipe?.duration ?? 30;
    _difficulty = widget.recipe?.difficulty ?? Difficulty.easy;
    _isVegetarian = widget.recipe?.isVegetarian ?? false;
    _isVegan = widget.recipe?.isVegan ?? false;
    _isGlutenFree = widget.recipe?.isGlutenFree ?? false;
    _isHalal = widget.recipe?.isHalal ?? false;
    _isKosher = widget.recipe?.isKosher ?? false;
    _ingredients = widget.recipe?.ingredients ?? [];
    _instructions = widget.recipe?.instructions ?? "";
    _defaultPortionAmount = widget.recipe?.defaultPortionAmount ?? 4;
    _image = widget.recipe?.image;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(
        currentIndex: 0,
      ),
      appBar: AppBar(
        title: Text(
          widget.recipe == null
              ? AppLocalizations.of(context)!.createRecipeHeadline
              : AppLocalizations.of(context)!.editRecipeHeadline,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: widget._formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagePickerWidget(
                onChanged: (value) => _image = value,
                recipeImage: widget.recipe?.image,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.titleEmptyError;
                  }
                  return null;
                },
                maxLength: 64,
                initialValue: _title,
                onChanged: (value) => _title = value,
                decoration: InputDecoration(hintText: AppLocalizations.of(context)!.titleInputLabel),
              ),
              const SizedBox(
                height: 16,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ToggleableLabelWidget(
                      image: SpiceSquadIconImages.cheese,
                      name: AppLocalizations.of(context)!.labelVegetarian,
                      initialActive: _isVegetarian,
                      onChanged: (value) => _isVegetarian = value,
                    ),
                    ToggleableLabelWidget(
                      image: SpiceSquadIconImages.avocado,
                      name: AppLocalizations.of(context)!.labelVegan,
                      initialActive: _isVegan,
                      onChanged: (value) => _isVegan = value,
                    ),
                    ToggleableLabelWidget(
                      image: SpiceSquadIconImages.glutenFree,
                      name: AppLocalizations.of(context)!.labelGlutenFree,
                      initialActive: _isGlutenFree,
                      onChanged: (value) => _isGlutenFree = value,
                    ),
                    ToggleableLabelWidget(
                      image: SpiceSquadIconImages.islam,
                      name: AppLocalizations.of(context)!.labelHalal,
                      initialActive: _isHalal,
                      onChanged: (value) => _isHalal = value,
                    ),
                    ToggleableLabelWidget(
                      image: SpiceSquadIconImages.judaism,
                      name: AppLocalizations.of(context)!.labelKosher,
                      initialActive: _isKosher,
                      onChanged: (value) => _isKosher = value,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.durationEmptyError;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      initialValue: _duration.toString(),
                      textAlign: TextAlign.center,
                      onChanged: (value) => {if (value != "") _duration = int.parse(value)},
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.durationInputLabel,
                        suffixText: AppLocalizations.of(context)!.durationUnit,
                        prefixIcon:
                            const Padding(padding: EdgeInsets.all(10), child: ImageIcon(SpiceSquadIconImages.timer)),
                        prefixIconColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: DifficultyPickerWidget(
                        initialValue: _difficulty,
                        onChanged: (value) => _difficulty = value,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              PortionAmountField(
                onChanged: (value) {
                  setState(() {
                    _defaultPortionAmount = value;
                  });
                },
                initialValue: widget.recipe?.defaultPortionAmount ?? 4,
              ),
              const SizedBox(
                height: 16,
              ),
              IngredientList(
                initialList: widget.recipe?.ingredients ?? [],
                onChanged: (List<Ingredient> value) {
                  setState(() {
                    _ingredients = value;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                AppLocalizations.of(context)!.instructionsHeadline,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.instructionsEmptyError;
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                onChanged: (value) => _instructions = value,
                initialValue: _instructions,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.instructionsInputLabel,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: Consumer(
                  builder: (context, ref, child) => ElevatedButton(
                    onPressed: () {
                      if (widget._formKey.currentState!.validate()) {
                        saveRecipe(ref.read(recipeServiceProvider.notifier));
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.saveButtonLabel),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveRecipe(RecipeService recipeService) {
    // update recipe
    if (widget.recipe != null) {
      final Recipe recipeUploadData = Recipe(
        id: widget.recipe!.id,
        title: _title,
        duration: _duration,
        instructions: _instructions,
        defaultPortionAmount: _defaultPortionAmount,
        ingredients: _ingredients,
        isGlutenFree: _isGlutenFree,
        isHalal: _isHalal,
        isKosher: _isKosher,
        isVegan: _isVegan,
        isVegetarian: _isVegetarian,
        image: _image,
        difficulty: _difficulty,
        author: widget.recipe!.author,
        uploadDate: widget.recipe!.uploadDate,
        isFavourite: widget.recipe!.isFavourite,
        isPrivate: widget.recipe!.isPrivate,
      );
      return recipeService.updateRecipe(recipeUploadData);
    }
    // create recipe
    final RecipeCreationData recipeCreationData = RecipeCreationData(
      title: _title,
      duration: _duration,
      instructions: _instructions,
      defaultPortionAmount: _defaultPortionAmount,
      ingredients: _ingredients,
      isGlutenFree: _isGlutenFree,
      isHalal: _isHalal,
      isKosher: _isKosher,
      isVegan: _isVegan,
      isVegetarian: _isVegetarian,
      image: _image,
      difficulty: _difficulty,
    );
    return recipeService.createRecipe(recipeCreationData);
  }
}
