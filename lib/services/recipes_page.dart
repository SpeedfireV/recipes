import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/services/firebase.dart';

import '../models/recipe.dart';

part 'recipes_page.g.dart';

@riverpod
Future<List<Recipe>> recipes(ref) async {
  return await FirestoreServices().getRecipes();
}
