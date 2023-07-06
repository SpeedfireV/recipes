import 'package:flutter_riverpod/flutter_riverpod.dart';

final ingredientsSearchProvider = StateProvider.autoDispose<String>((ref) {
  return "";
});
final selectedIngredientsProvider = StateProvider<List<String>>((ref) {
  return [];
});
