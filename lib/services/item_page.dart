import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/services/auth.dart';
import 'package:sports/services/firebase.dart';

part 'item_page.g.dart';

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

@riverpod
class LikedStream extends _$LikedStream {
  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> build() async* {
    yield* FirestoreServices().getLikedRecipes();
  }

  Future<bool> likeRecipe(String recipe) async {
    return await FirestoreServices().likeRecipe(recipe);
  }

  Future<bool> unlikeRecipe(String recipe) async {
    return await FirestoreServices().unlikeRecipe(recipe);
  }
}
