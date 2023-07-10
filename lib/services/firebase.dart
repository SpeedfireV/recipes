import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sports/services/auth.dart';

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
}
