import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/models/ingredient.dart';
import 'package:sports/services/firebase.dart';

part 'add_ingredient.g.dart';

@riverpod
class IngredientsStream extends _$IngredientsStream {
  @override
  Stream<List<Future<Ingredient>>> build() async* {
    yield* FirestoreServices().getIngredientsStream();
  }
}

final ingredientImageProvider = StateProvider.autoDispose<File?>((ref) {
  return;
});

final ingredientImagePickedProvider =
    StateProvider.autoDispose<bool>((ref) => true);

final ingredientsSelectedProvider =
    StateProvider.autoDispose<bool>((ref) => true);

final imagesSelectedProvider = StateProvider.autoDispose<bool>((ref) => true);
