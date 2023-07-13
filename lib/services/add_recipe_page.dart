import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_recipe_page.g.dart';

final categoryProvider = StateProvider.autoDispose<String>((ref) {
  return "";
});

final estimatedTimeProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

@riverpod
class SelectedIngredients extends _$SelectedIngredients {
  @override
  List<String> build() {
    return [];
  }

  addIngredient(String ingredient) {
    if (!state.contains(ingredient)) {
      state = [...state, ingredient];
    } else {
      deleteIngredient(ingredient);
    }
  }

  deleteIngredient(String ingredient) {
    List<String> newState = state;
    newState.remove(ingredient);
    state = newState;
  }

  clearIngredients() {
    state = [];
  }
}

@riverpod
class SelectedImages extends _$SelectedImages {
  @override
  List<PlatformFile> build() {
    return [];
  }

  addImages(List<PlatformFile> images) {
    List<PlatformFile> newState = state;
    for (int i = 0; i < images.length; i++) {
      newState.add(images.elementAt(i));
    }
    state = newState;
  }

  deleteImage(image) {
    List<PlatformFile> newState = state;
    newState.remove(image);
    state = newState;
  }

  clearImages() {
    state = [];
  }
}
