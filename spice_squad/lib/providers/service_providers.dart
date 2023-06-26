import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/services/recipe_service.dart';

import '../models/recipe.dart';

final recipeServiceProvider = AsyncNotifierProvider<RecipeService, List<Recipe>>(() => RecipeService());
