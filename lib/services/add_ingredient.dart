import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/models/ingredient.dart';
import 'package:sports/services/firebase.dart';

part 'add_ingredient.g.dart';

@riverpod
class IngredientsStream extends _$IngredientsStream {
  @override
  Stream<List<Future<Ingredient>>> build() async* {
    yield* FirestoreServices().getIngredients();
  }
}
