import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/services/auth.dart';
import 'package:sports/services/firebase.dart';

final tabSelectorProvider = StateProvider.autoDispose<int>((ref) => 0);
final passwordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);
final loggedInProvider = StateProvider<bool>((ref) => AuthService.loggedIn());
final imagePositionProvider = StateProvider.autoDispose<int>((ref) => 0);

final itemPageIngredientImageProvider = FutureProvider.autoDispose.family(
    (ref, String ingredient) =>
        StorageServices().getIngredientImage(ingredient));

final recipeImagesProvider =
    FutureProvider.autoDispose.family((ref, String recipe) async {
  List<Uint8List?>? recipes = await StorageServices().getRecipeImages(recipe);
  if (recipes != null) {
    return recipes;
  } else {
    return [];
  }
});
