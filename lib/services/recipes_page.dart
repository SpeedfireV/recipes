import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/services/firebase.dart';

import '../models/recipe.dart';

part 'recipes_page.g.dart';

final categoryFilterProvider = StateProvider<String>((ref) {
  return "All";
});

@riverpod
Future<List<Recipe>> recipes(ref) async {
  return await FirestoreServices().getRecipes();
}
