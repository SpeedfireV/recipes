import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:sports/models/ingredient.dart';
import 'package:sports/services/auth.dart';
import 'package:sports/services/local_database.dart';

import '../models/image.dart';
import '../models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future addRecipe(Recipe recipe) async {
    recipe.toJson();
    CollectionReference recipes = firestore.collection("recipes");
    recipes
        .add(recipe.toJson())
        .then((value) => null)
        .catchError((error) => print("failed due to $error"));
  }

  Future addCategory(String categoryName) async {
    CollectionReference categories = firestore.collection("categories");
    categories.add({"category": categoryName});
  }

  Future addIngredient(String ingredient, File image) async {
    CollectionReference ingredients = firestore.collection("ingredients");
    (await StorageServices().addIngredient(ingredient, image));
    ingredients.add({"ingredient": ingredient});
  }

  Future<bool> likeRecipe(String recipe) async {
    if (!AuthService.loggedIn()) {
      return false;
    }
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await firestore.collection("users").doc(AuthService.currentUid()).get();

    if (userDoc.exists) {
      if (userDoc.data()!.containsKey("liked")) {
        await firestore.collection("users").doc(AuthService.currentUid()).set({
          "liked": [...(await userDoc.data()!["liked"]), recipe]
        });

        return true;
      } else {
        await firestore.collection("users").doc(AuthService.currentUid()).set({
          "liked": [recipe]
        });
        return true;
      }
    }
    return true;
  }

  Future<bool> unlikeRecipe(String recipe) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await firestore.collection("users").doc(AuthService.currentUid()).get();

    if (userDoc.exists) {
      if (userDoc.data()!.containsKey("liked")) {
        List<dynamic> currentlyLiked = await userDoc.data()!["liked"];
        currentlyLiked.remove(recipe);

        await firestore.collection("users").doc(AuthService.currentUid()).set({
          "liked": [...currentlyLiked]
        });

        return true;
      }
    }
    return true;
  }

  Future<bool> profileCreated() async {
    CollectionReference<Map<String, dynamic>> users =
        firestore.collection("users");
    DocumentSnapshot<Map<String, dynamic>> usersData =
        await users.doc(AuthService.currentUid()).get();
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

  Stream<List<Future<Ingredient>>> getIngredientsStream() async* {
    CollectionReference ingredients = firestore.collection("ingredients");
    final Stream<QuerySnapshot> snapshots = ingredients.snapshots();
    final stream = snapshots.map((snapshot) {
      final result = snapshot.docs.map((element) async {
        String ingredientName = element["ingredient"] as String;
        Ingredient ingredient = Ingredient(
            name: ingredientName,
            image: await StorageServices().getIngredientImage(ingredientName) ??
                Uint8List(0),
            volume: "");
        return ingredient;
      }).toList();
      return result;
    });
    yield* stream;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getLikedRecipes() async* {
    Stream<DocumentSnapshot<Map<String, dynamic>>>? snapshots =
        FirebaseFirestore.instance
            .collection('users')
            .doc(AuthService.currentUid())
            .snapshots();
    final stream = snapshots;
    yield* stream;
  }

  Future<List<Recipe>> getRecipes() async {
    CollectionReference recipes = firestore.collection("recipes");
    List<Recipe> recipesList = [];
    List<DocumentSnapshot> futureRecipes = (await recipes.get()).docs;
    for (var recipe in futureRecipes) {
      List<String> ingredients = [];
      for (String ingredient in recipe.get("ingredients")) {
        ingredients.add(ingredient);
      }
      recipesList.add(Recipe(
          name: recipe.get("name"),
          recipe: recipe.get("recipe"),
          description: recipe.get("description"),
          estimatedTime: recipe.get("estimatedTime"),
          category: recipe.get("category"),
          ingredients: ingredients));
    }

    return recipesList;
  }

  Future<bool> isAdmin() async {
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

  Future addRecipeImages(
      List<ImageWithMetadata> images, String recipeName) async {
    final storageImages = storage.child("recipes").child(recipeName);

    for (int i = 0; i < images.length; i++) {
      final file = File(images.elementAt(i).image.path!);
      if (images.elementAt(i).main) {
        storageImages
            .child("main")
            .child("/${images.elementAt(i).image.name}")
            .putFile(file)
            .then((p0) => print(p0))
            .onError((error, stackTrace) => print('failed due to $error'));
      } else {
        storageImages
            .child("/${images.elementAt(i).image.name}")
            .putFile(file)
            .then((p0) => print(p0))
            .onError((error, stackTrace) => print('failed due to $error'));
      }
    }
  }

  Future addIngredient(String ingredient, File image) async {
    final storageCategories = storage.child("ingredients").child(ingredient);
    final file = File(image.path);
    await storageCategories
        .child("/$ingredient")
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

  Future<Uint8List?> getMainRecipeImage(String imageProvided) async {
    final storageRecipes =
        storage.child("recipes").child(imageProvided).child("main");
    String imageName = (await storageRecipes.list()).items.elementAt(0).name;
    try {
      final image = await storageRecipes.child(imageName).getData();
      if (image != null) {
        LocalDatabaseServices().addRecipeImage(imageProvided, image);

        return image;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      debugPrint("Error due to $e");
      return null;
    }
  }

  Future<List<Uint8List>?> getRecipeImages(String recipeName) async {
    final storageRecipes = storage.child("recipes").child(recipeName);
    List<Reference> imagesName = (await storageRecipes.list()).items;
    List<Uint8List> images = [];
    for (Reference imageReference in imagesName) {
      try {
        String imageName = imageReference.name;
        final image = await storageRecipes.child(imageName).getData();
        if (image != null) images.add(image);
      } on FirebaseException {
        return null;
      }
    }
    if (images.isNotEmpty) {
      return images;
    }
    return null;
  }

  Future<Uint8List?> getIngredientImage(String ingredient) async {
    final storageCategories = storage.child("ingredients").child(ingredient);
    final items = (await storageCategories.list()).items;
    late String imageName;
    try {
      imageName = items.elementAt(0).name;
    } on RangeError {
      return null;
    }
    try {
      final image = await storageCategories.child(imageName).getData();
      return image;
    } on FirebaseException catch (e) {
      debugPrint("Error due to $e");
      return null;
    }
  }
}
