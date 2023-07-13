import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/services/firebase.dart';

part 'category_picker.g.dart';

final categoryImageProvider = StateProvider.autoDispose<File?>((ref) {
  return;
});

final categoryImagePickedProvider =
    StateProvider.autoDispose<bool>((ref) => true);

@riverpod
Stream<List<String>> categories(
  ref,
) async* {
  yield* FirestoreServices().getCategories();
}
