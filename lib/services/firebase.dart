import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:sports/models/ingredient.dart';
import 'package:sports/services/auth.dart';
import 'package:sports/services/category_picker.dart';

import '../models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future addRecipe(Recipe recipe) async {
    recipe.toJson();
    CollectionReference recipes = firestore.collection("recipes");
    recipes
        .add(recipe.toJson())
        .then((value) => print(value))
        .catchError((error) => print("failed due to $error"));
  }

  Future addCategory(String categoryName) async {
    CollectionReference categories = firestore.collection("categories");
    categories.add({"category": categoryName});
  }

  Future addIngredient(String ingredient, File image) async {
    CollectionReference ingredients = firestore.collection("ingredients");
    StorageServices().addIngredient(ingredient, image);
    ingredients.add({"ingredient": ingredient});
  }

  Future<bool> profileCreated() async {
    CollectionReference users = firestore.collection("users");
    DocumentSnapshot<Map<String, dynamic>> usersData = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(AuthService.currentUid())
        .get();
    if (usersData.exists) {
      return true;
    } else {
      return false;
    }
  }

  Stream<List<String>> getCategories() async* {
    CollectionReference categories = firestore.collection("categories");
    final Stream<QuerySnapshot> snapshots = categories.snapshots();
    Stream<List<String>> stream = snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((element) => element["category"] as String)
          .toList();
      return result;
    });
    yield* stream;
  }

  Stream<List<Future<Ingredient>>> getIngredients() async* {
    CollectionReference ingredients = firestore.collection("ingredients");
    final Stream<QuerySnapshot> snapshots = ingredients.snapshots();
    final stream = snapshots.map((snapshot) {
      final result = snapshot.docs.map((element) async {
        String ingredientName = element["ingredient"] as String;
        Ingredient ingredient = Ingredient(
            name: ingredientName,
            image: await StorageServices().getIngredientImage(ingredientName) ??
                "",
            selected: false);
        return ingredient;
      }).toList();
      return result;
    });
    yield* stream;
  }

  Future<bool> isAdmin() async {
    CollectionReference users = firestore.collection("users");
    DocumentSnapshot<Map<String, dynamic>> usersData = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(AuthService.currentUid())
        .get();
    if (usersData.exists && usersData.data()!["admin"] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future createNewProfile() async {
    CollectionReference users = firestore.collection("users");
    users.doc(AuthService.currentUid()).set({"admin": false});
  }
}

class StorageServices {
  final storage = FirebaseStorage.instance.ref();

  Future addRecipeImages(List<PlatformFile> images, String recipeName) async {
    final storageImages = storage.child("recipes").child(recipeName);

    for (int i = 0; i < images.length; i++) {
      final file = File(images.elementAt(i).path!);
      storageImages
          .child("/${images.elementAt(i).name}")
          .putFile(file)
          .then((p0) => print(p0))
          .onError((error, stackTrace) => print('failed due to $error'));
    }
  }
  /*
  Future addCategory(String category, File image) async {
    final storageCategories = storage.child("categories").child(category);
    final file = File(image.path);
    storageCategories
        .child("/${category}")
        .putFile(file)
        .then((p0) => print(p0))
        .onError((error, stackTrace) => print('failed due to $error'));
  }
  */

  Future addIngredient(String ingredient, File image) async {
    final storageCategories = storage.child("ingredients").child(ingredient);
    final file = File(image.path);
    storageCategories
        .child("/${ingredient}")
        .putFile(file)
        .then((p0) => print(p0))
        .onError((error, stackTrace) => print('failed due to $error'));
  }

  Future<Uint8List?> getCategoryImage(String category) async {
    final storageCategories = storage.child("categories").child(category);
    String imageName = (await storageCategories.list()).items.elementAt(0).name;
    try {
      final image = await storageCategories.child(imageName).getData();
      return image!;
    } on FirebaseException catch (e) {
      debugPrint("Error due to $e");
      return null;
    }
  }

  Future<String?> getIngredientImage(String ingredient) async {
    final storageCategories = storage.child("ingredients").child(ingredient);
    String imageName = (await storageCategories.list()).items.elementAt(0).name;
    try {
      final image = await storageCategories.child(imageName).getDownloadURL();
      return image;
    } on FirebaseException catch (e) {
      debugPrint("Error due to $e");
      return null;
    }
  }
}
