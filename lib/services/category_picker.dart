import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/services/firebase.dart';

part 'category_picker.g.dart';

@riverpod
Stream<List<String>> categories(
  ref,
) async* {
  yield* FirestoreServices().getCategories();
}
