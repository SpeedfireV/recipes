import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabaseServices {
  Box box = Hive.box("launch");
  Box recipesImagesBox = Hive.box("recipesImages");
  Box ingredientsImagesBox = Hive.box("ingredientsImages");
  Future addToBox() async {
    box.add(true);
  }

  bool appLaunched() {
    if (box.values.length == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future addRecipeImage(String category, Uint8List image) async {
    await recipesImagesBox.put(category, image);
  }

  Uint8List? getRecipeImage(String category) {
    Uint8List? image = recipesImagesBox.get(category);
    if (image != null) {
      return image;
    }
    return null;
  }

  Future addIngredientImage(String ingredient, Uint8List image) async {
    await ingredientsImagesBox.put(ingredient, image);
  }

  Uint8List? getIngredientImage(String ingredient) {
    Uint8List? image = ingredientsImagesBox.get(ingredient);
    if (image != null) {
      return image;
    }
    return null;
  }
}
