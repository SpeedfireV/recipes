import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/services/firebase.dart';
import 'package:sports/services/local_database.dart';

import '../models/recipe.dart';

part 'recipes_page.g.dart';

final categoryFilterProvider = StateProvider<String>((ref) {
  return "All";
});

final scrollPositionProvider = StateProvider.autoDispose((ref) => 0);

final recipeMainImageProvider =
    FutureProvider.autoDispose.family((ref, String recipeName) async {
  if (LocalDatabaseServices().getRecipeImage(recipeName) != null) {
    return LocalDatabaseServices().getRecipeImage(recipeName);
  } else {
    return StorageServices().getMainRecipeImage(recipeName);
  }
});

@riverpod
Future<List<Recipe>> recipes(ref) async {
  return await FirestoreServices().getRecipes();
}
