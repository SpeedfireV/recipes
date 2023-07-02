import 'package:go_router/go_router.dart';
import 'package:sports/pages/entry_page.dart';
import 'package:sports/pages/recipes_page.dart';

import '../pages/login_page.dart';

class RouterServices {
  static final router = GoRouter(routes: [
    GoRoute(path: "/", builder: (context, state) => EntryPage()),
    GoRoute(
        path: "/recipes",
        name: "recipes",
        builder: (context, state) => RecipesPage()),
    GoRoute(
        path: "/login", name: "login", builder: (context, state) => LoginPage())
  ]);
}
