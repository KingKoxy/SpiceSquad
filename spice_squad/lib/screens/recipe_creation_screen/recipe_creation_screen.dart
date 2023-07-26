import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/recipe_creation_data.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/screens/recipe_creation_screen/difficulty_picker_widget.dart";
import "package:spice_squad/screens/recipe_creation_screen/image_picker_widget.dart";
import "package:spice_squad/screens/recipe_creation_screen/ingredient_list.dart";
import "package:spice_squad/services/recipe_service.dart";
import "package:spice_squad/widgets/approval_dialog.dart";
import "package:spice_squad/widgets/nav_bar.dart";
import "package:spice_squad/widgets/portion_amount_field.dart";
import "package:spice_squad/widgets/tag_item.dart";

/// Screen for creating a new recipe
class RecipeCreationScreen extends ConsumerStatefulWidget {
  /// Route name for navigation
  static const routeName = "/recipe-creation";

  final _formKey = GlobalKey<FormState>();

  /// The recipe to edit if this screen is used for editing
  final Recipe? recipe;

  /// Creates a new recipe creation screen
  RecipeCreationScreen({required this.recipe, super.key});

  @override
  ConsumerState<RecipeCreationScreen> createState() => _RecipeCreationScreenState();
}

class _RecipeCreationScreenState extends ConsumerState<RecipeCreationScreen> {
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
  bool _isLoading = false;

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
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        bottomNavigationBar: widget.recipe == null
            ? const NavBar(
          currentIndex: 0,
        )
            : null,
        appBar: AppBar(
          title: Text(
            widget.recipe == null
                ? AppLocalizations.of(context)!.createRecipeHeadline
                : AppLocalizations.of(context)!.editRecipeHeadline,
          ),
          leading: widget.recipe != null
              ? BackButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text(AppLocalizations.of(context)!.saveBeforeAbortEditTitle),
                      content: Text(AppLocalizations.of(context)!.saveBeforeAbortEditMessage),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppLocalizations.of(
                            context)!.cancelButtonLabel,),),
                        TextButton(onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }, child: Text(AppLocalizations.of(context)!.discardButtonLabel)),
                        TextButton(onPressed: () => saveRecipe(ref.read(recipeServiceProvider.notifier)),
                            child: Text(AppLocalizations.of(context)!.saveButtonLabel)),
                      ],
                    ),
              );
            },
          )
              : null,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: widget._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImagePickerWidget(
                  onChanged: (value) =>
                      setState(() {
                        _image = value;
                      }),
                  recipeImage: _image,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.titleEmptyError;
                    }
                    if (value.length > 64) {
                      return AppLocalizations.of(context)!.titleTooLongError;
                    }
                    return null;
                  },
                  initialValue: _title,
                  onChanged: (value) => _title = value,
                  decoration: InputDecoration(hintText: AppLocalizations.of(context)!.titleInputLabel),
                ),
                const SizedBox(
                  height: 16,
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TagItem(
                        image: SpiceSquadIconImages.cheese,
                        name: AppLocalizations.of(context)!.labelVegetarian,
                        initialActive: _isVegetarian,
                        onToggle: (value) => _isVegetarian = value,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      TagItem(
                        image: SpiceSquadIconImages.avocado,
                        name: AppLocalizations.of(context)!.labelVegan,
                        initialActive: _isVegan,
                        onToggle: (value) => _isVegan = value,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      TagItem(
                        image: SpiceSquadIconImages.glutenFree,
                        name: AppLocalizations.of(context)!.labelGlutenFree,
                        initialActive: _isGlutenFree,
                        onToggle: (value) => _isGlutenFree = value,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      TagItem(
                        image: SpiceSquadIconImages.islam,
                        name: AppLocalizations.of(context)!.labelHalal,
                        initialActive: _isHalal,
                        onToggle: (value) => _isHalal = value,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      TagItem(
                        image: SpiceSquadIconImages.judaism,
                        name: AppLocalizations.of(context)!.labelKosher,
                        initialActive: _isKosher,
                        onToggle: (value) => _isKosher = value,
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
                      flex: 3,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.durationEmptyError;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[1-9]\d*")),
                        ],
                        initialValue: _duration.toString(),
                        textAlign: TextAlign.center,
                        onChanged: (value) => {if (value != "") _duration = int.parse(value)},
                        maxLength: 3,
                        decoration: InputDecoration(
                          counterText: "",
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
                      flex: 2,
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium,
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
                  child: ElevatedButton(
                    onPressed: () async {
                      if (widget._formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        await saveRecipe(ref.read(recipeServiceProvider.notifier)).then(
                              (value) => Navigator.of(context).pushReplacementNamed(MainScreen.routeName),
                        );
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(AppLocalizations.of(context)!.saveButtonLabel),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveRecipe(RecipeService recipeService) {
    // update recipe
    if (widget.recipe != null) {
      final Recipe recipeUploadData = widget.recipe!.copyWith(
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
        setImageIfNull: true,
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
