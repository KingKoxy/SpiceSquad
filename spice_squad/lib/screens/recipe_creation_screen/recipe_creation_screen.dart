import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:http/http.dart" as http;
import "package:spice_squad/icons.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/models/recipe_creation_data.dart";
import "package:spice_squad/providers/repository_providers.dart";
import "package:spice_squad/providers/service_providers.dart";
import "package:spice_squad/repositories/image_repository.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/screens/recipe_creation_screen/difficulty_picker_widget.dart";
import "package:spice_squad/screens/recipe_creation_screen/image_picker_widget.dart";
import "package:spice_squad/screens/recipe_creation_screen/ingredient_list.dart";
import "package:spice_squad/services/recipe_service.dart";
import "package:spice_squad/widgets/nav_bar.dart";
import "package:spice_squad/widgets/portion_amount_field.dart";
import "package:spice_squad/widgets/tag_item.dart";

/// Screen for creating a new recipe
class RecipeCreationScreen extends ConsumerStatefulWidget {
  /// Route name for navigation
  static const routeName = "/recipe-creation";

  final _formKey = GlobalKey<FormState>();

  /// The recipe to edit if this screen is used for editing
  final Recipe? _recipe;

  /// Creates a new recipe creation screen
  RecipeCreationScreen({required Recipe? recipe, super.key}) : _recipe = recipe;

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
  late Future<Uint8List?>? _imageFuture;
  bool _isLoading = false;

  @override
  void initState() {
    _title = widget._recipe?.title ?? "";
    _duration = widget._recipe?.duration ?? 30;
    _difficulty = widget._recipe?.difficulty ?? Difficulty.easy;
    _isVegetarian = widget._recipe?.isVegetarian ?? false;
    _isVegan = widget._recipe?.isVegan ?? false;
    _isGlutenFree = widget._recipe?.isGlutenFree ?? false;
    _isHalal = widget._recipe?.isHalal ?? false;
    _isKosher = widget._recipe?.isKosher ?? false;
    _ingredients = widget._recipe?.ingredients ?? [];
    _instructions = widget._recipe?.instructions ?? "";
    _defaultPortionAmount = widget._recipe?.defaultPortionAmount ?? 4;
    _imageFuture = widget._recipe?.imageUrl.isEmpty ?? true
        ? null
        : http.get(Uri.parse(widget._recipe!.imageUrl)).then((value) => value.bodyBytes);
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
        bottomNavigationBar: widget._recipe == null
            ? const NavBar(
                currentIndex: 0,
              )
            : null,
        appBar: AppBar(
          title: Text(
            widget._recipe == null
                ? AppLocalizations.of(context)!.createRecipeHeadline
                : AppLocalizations.of(context)!.editRecipeHeadline,
          ),
          leading: widget._recipe != null
              ? BackButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!.saveBeforeAbortEditTitle),
                        content: Text(AppLocalizations.of(context)!.saveBeforeAbortEditMessage),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!
                                  .cancelButtonLabel,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text(AppLocalizations.of(context)!.discardButtonLabel),
                          ),
                          TextButton(
                            onPressed: () => _saveRecipe(
                              ref.read(recipeServiceProvider.notifier),
                              ref.read(imageRepositoryProvider),
                            ).then((value) => Navigator.of(context).pop()),
                            child: Text(AppLocalizations.of(context)!.saveButtonLabel),
                          ),
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
                FutureBuilder(
                  future: _imageFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return ImagePickerWidget(
                      onChanged: (value) => setState(() {
                        _imageFuture = Future.delayed(Duration.zero, () => value);
                      }),
                      recipeImage: snapshot.data,
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  key: const Key("recipeNameField"),
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
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.titleInputLabel,
                  ),
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
                        key: const Key("veganTag"),
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
                        key: const Key("recipeDurationField"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.durationEmptyError;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r"[1-9]\d*"),
                          ),
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
                  initialValue: widget._recipe?.defaultPortionAmount ?? 4,
                ),
                const SizedBox(
                  height: 16,
                ),
                IngredientList(
                  initialList: widget._recipe?.ingredients ?? [],
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
                  key: const Key("recipeInstructionsField"),
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
                    key: const Key("saveRecipeButton"),
                    onPressed: () async {
                      if (widget._formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        await _saveRecipe(ref.read(recipeServiceProvider.notifier), ref.read(imageRepositoryProvider))
                            .then(
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

  Future<void> _saveRecipe(RecipeService recipeService, ImageRepository imageRepository) async {
    String imageUrl;
    final Uint8List? image = await _imageFuture;
    if (widget._recipe?.imageUrl.isNotEmpty ?? false) {
      imageUrl = await imageRepository.updateImage(widget._recipe!.imageUrl, image);
    } else {
      imageUrl = await imageRepository.uploadImage(image);
    }
    // update recipe
    if (widget._recipe != null) {
      final Recipe recipeUploadData = widget._recipe!.copyWith(
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
        difficulty: _difficulty,
        imageUrl: imageUrl,
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
      imageUrl: imageUrl,
      difficulty: _difficulty,
    );
    return recipeService.createRecipe(recipeCreationData);
  }
}
