import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sports/models/food_item.dart';
import 'package:sports/pages/add_recipe.dart';
import 'package:sports/pages/category_picker.dart';
import 'package:sports/pages/entry_page.dart';
import 'package:sports/pages/find_by_ingredient.dart';
import 'package:sports/pages/recipes_page.dart';
import 'package:sports/services/local_database.dart';

import '../pages/item_page.dart';
import '../pages/login_page.dart';

class RouterServices {
  static final router = GoRouter(routes: [
    GoRoute(
        path: "/",
        builder: (context, state) {
          if (DatabaseServices.appLaunched()) {
            return RecipesPage();
          }
          return EntryPage();
        }),
    GoRoute(
        path: "/recipes",
        name: "recipes",
        builder: (context, state) => const RecipesPage()),
    GoRoute(
        path: "/addRecipe",
        name: "addRecipe",
        builder: (context, state) => const AddRecipePage()),
    GoRoute(
        path: "/addCategory",
        name: "addCategory",
        builder: (context, state) => const AddCategoryPage()),
    GoRoute(
        path: "/category",
        name: "category",
        builder: (context, state) {
          List list = state.extra as List;
          return PickerPage(
            list[0] as TextEditingController,
            list[1] as String,
          );
        }),
    GoRoute(
        path: "/ingredients",
        name: "ingredients",
        builder: (context, state) {
          String? customText = state.extra as String?;
          return ByIngredientPage(text: customText);
        }),
    GoRoute(
        path: "/login",
        name: "login",
        builder: (context, state) => const LoginPage()),
    GoRoute(
      path: "/recipe",
      name: "recipe",
      builder: (context, state) {
        FoodItem item = state.extra as FoodItem;
        return RecipePage(item: item);
      },
    )
  ]);
}
