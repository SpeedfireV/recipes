import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sports/models/ingredient.dart';
import 'package:sports/services/firebase.dart';

import '../models/image.dart';

part 'add_recipe_page.g.dart';

final adminProvider =
    FutureProvider<Future<bool>>((ref) => FirestoreServices().isAdmin());

final categoryProvider = StateProvider.autoDispose<String>((ref) {
  return "";
});

final estimatedTimeProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

@riverpod
class SelectedIngredients extends _$SelectedIngredients {
  @override
  List<Ingredient> build() {
    return [];
  }

  addIngredient(Ingredient ingredient) {
    state = [...state, ingredient];
  }

  changeIngredients(Ingredient ingredient) {
    if (ingredientExists(ingredient.name)) {
      deleteIngredient(ingredient.name);
    } else {
      addIngredient(ingredient);
    }
  }

  deleteIngredient(String ingredient) {
    List<Ingredient> finalState = [];
    for (Ingredient localIngredient in state) {
      if (localIngredient.name != ingredient) {
        finalState.add(localIngredient);
      }
    }
    state = finalState;
  }

  ingredientExists(String name) {
    for (Ingredient ingredient in state) {
      if (ingredient.name == name) {
        return true;
      }
    }
    return false;
  }

  clearIngredients() {
    state = [];
  }
}

@riverpod
class SelectedImages extends _$SelectedImages {
  @override
  List<ImageWithMetadata> build() {
    return [];
  }

  addImages(List<ImageWithMetadata> images) {
    List<ImageWithMetadata> newState = state;
    List<ImageWithMetadata> finalState = [...newState];

    for (int i = 0; i < images.length; i++) {
      finalState.add(images.elementAt(i));
    }
    state = finalState;
  }

  deleteImage(String image) {
    List<ImageWithMetadata> newState = state;
    List<ImageWithMetadata> finalState = [];
    finalState.addAll(newState);
    for (int i = 0; i < finalState.length; i++) {
      if (finalState.elementAt(i).image.name == image) {
        bool newMain = false;
        if (finalState.elementAt(i).main) {
          newMain = true;
        }
        finalState.removeAt(i);
        if (newMain && finalState.isNotEmpty) {
          finalState = [
            ImageWithMetadata(image: finalState.elementAt(0).image, main: true),
            ...finalState.sublist(1)
          ];
        }
        break;
      }
    }
    state = finalState;
  }

  setMainImage(String image) {
    List<ImageWithMetadata> newState = state;
    List<ImageWithMetadata> finalState = [];
    for (int i = 0; i < newState.length; i++) {
      if (newState.elementAt(i).image.name == image) {
        finalState.add(
            ImageWithMetadata(image: newState.elementAt(i).image, main: true));
      } else if (newState.elementAt(i).main) {
        finalState.add(
            ImageWithMetadata(image: newState.elementAt(i).image, main: false));
      } else {
        finalState.add(newState.elementAt(i));
      }
    }
    state = finalState;
  }

  clearImages() {
    state = [];
  }
}
