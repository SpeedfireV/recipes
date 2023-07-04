import 'package:go_router/go_router.dart';
import 'package:sports/models/food_item.dart';
import 'package:sports/pages/entry_page.dart';
import 'package:sports/pages/recipes_page.dart';

import '../pages/item_page.dart';
import '../pages/login_page.dart';

class RouterServices {
  static final router = GoRouter(routes: [
    GoRoute(path: "/", builder: (context, state) => const EntryPage()),
    GoRoute(
        path: "/recipes",
        name: "recipes",
        builder: (context, state) => const RecipesPage()),
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
