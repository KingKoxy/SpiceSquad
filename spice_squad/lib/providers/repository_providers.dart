import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spice_squad/repositories/remote_recipe_repository.dart';

final remoteRecipeProvider =
    Provider<RemoteRecipeRepository>((ref) => RemoteRecipeRepository());
