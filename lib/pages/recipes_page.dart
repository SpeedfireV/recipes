import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/constants/images.dart';
import 'package:sports/functions/time.dart';
import 'package:sports/models/food_item.dart';
import 'package:sports/pages/login_page.dart';
import 'package:sports/services/auth.dart';
import 'package:sports/services/category_picker.dart';
import 'package:sports/services/firebase.dart';
import 'package:sports/services/item_page.dart';
import 'package:sports/services/recipes_page.dart';
import 'package:sports/services/router.dart';

import '../widgets/elevated_button.dart';

class RecipesPage extends StatefulHookConsumerWidget {
  const RecipesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecipesPageState();
}

class _RecipesPageState extends ConsumerState<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    bool loggedIn = ref.watch(loggedInProvider);
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    final scrollController = useScrollController();
    final recipes = ref.watch(recipesProvider);
    final categories = ref.watch(categoriesProvider);
    final categoryFilter = ref.watch(categoryFilterProvider);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //TODO: To the top
          },
          child: Icon(Icons.arrow_upward_rounded),
        ),
        drawer: Drawer(child: Text("Working")),
        backgroundColor: ColorsCustom.background,
        body: ListView(
          controller: scrollController,
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: OutlinedIconButton(
                          function: () async {
                            if (loggedIn) {
                              showDialog(
                                  context: context,
                                  builder: (context) => LogOutDialog());
                            } else {
                              RouterServices.router.pushNamed("login");
                            }
                          },
                          icon: loggedIn
                              ? FontAwesomeIcons.rightFromBracket
                              : FontAwesomeIcons.user),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Delicious\n",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.grey[600])),
                          const TextSpan(
                              text: "Easy to cook menu",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 24))
                        ], style: TextStyle(color: ColorsCustom.darkGrey)),
                      ),
                      const SizedBox(height: 10),
                      CustomElevatedButton(
                          icon: FontAwesomeIcons.utensils,
                          function: () =>
                              RouterServices.router.pushNamed("ingredients"),
                          text: "Find Dish By Ingredients"),
                      const SizedBox(height: 20),
                      Text(
                        "Category",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: ColorsCustom.darkGrey),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: categories.when(
                            data: (data) {
                              List<String> possibleCategories = [
                                "All",
                                ...data
                              ];
                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final String category =
                                      possibleCategories.elementAt(index);
                                  return CategoryButton(
                                    text: category,
                                    activated: category == categoryFilter,
                                    index: index,
                                    function: () {
                                      ref
                                          .read(categoryFilterProvider.notifier)
                                          .state = category;
                                    },
                                  );
                                },
                                itemCount: possibleCategories.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 12),
                              );
                            },
                            error: (error, stackTrace) => Text("Error"),
                            loading: () {
                              return ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Shimmer.fromColors(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(24)),
                                        width: 140,
                                        height: 50,
                                      ),
                                      baseColor: ColorsCustom.lightGrey
                                          .withOpacity(0.3),
                                      highlightColor: ColorsCustom.background);
                                },
                                itemCount: 4,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 12),
                              );
                            }),
                      ),
                      const SizedBox(height: 20),
                      recipes.when(
                          data: (data) {
                            if (categoryFilter == "All") {
                              return GridView.builder(
                                  itemCount: data.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20,
                                          childAspectRatio: 6 / 7,
                                          crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    final currentRecipe = data.elementAt(index);
                                    return FoodItemElement(
                                        item: FoodItem(
                                            name: currentRecipe.name,
                                            description:
                                                currentRecipe.description,
                                            category: currentRecipe.category,
                                            rating: 45,
                                            time: currentRecipe.estimatedTime,
                                            ingredients:
                                                currentRecipe.ingredients,
                                            recipe: currentRecipe.recipe));
                                  });
                            } else {
                              final filteredItems = data.where((element) =>
                                  element.category == categoryFilter);
                              return GridView.builder(
                                  itemCount: filteredItems.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20,
                                          childAspectRatio: 6 / 7,
                                          crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    final currentRecipe =
                                        filteredItems.elementAt(index);
                                    return FoodItemElement(
                                        item: FoodItem(
                                            name: currentRecipe.name,
                                            description:
                                                currentRecipe.description,
                                            category: currentRecipe.category,
                                            rating: 45,
                                            time: currentRecipe.estimatedTime,
                                            ingredients:
                                                currentRecipe.ingredients,
                                            recipe: currentRecipe.recipe));
                                  });
                            }
                          },
                          error: (error, errorStack) {
                            return Text("data");
                          },
                          loading: () => Container()),
                      const SizedBox(height: 40)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class CategoryButton extends ConsumerStatefulWidget {
  const CategoryButton(
      {super.key,
      required this.text,
      required this.activated,
      required this.index,
      required this.function});
  final String text;
  final bool activated;
  final int index;
  final Function function;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends ConsumerState<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: widget.activated
                ? null
                : const MaterialStatePropertyAll(Colors.white),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)))),
        onPressed: () {
          widget.function.call();
        },
        child: Text(
          widget.text,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: widget.activated ? null : ColorsCustom.darkGrey),
        ));
  }
}

class FoodItemElement extends ConsumerStatefulWidget {
  const FoodItemElement({super.key, required this.item});
  final FoodItem item;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FoodItemElementState();
}

class _FoodItemElementState extends ConsumerState<FoodItemElement> {
  @override
  Widget build(BuildContext context) {
    final FoodItem item = widget.item;
    Future<Uint8List?> _getMainRecipeImage =
        StorageServices().getMainRecipeImage(item.name);
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 5,
      child: InkWell(
        onTap: () {
          RouterServices.router.pushNamed("recipe", extra: item);
        },
        child: Ink(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                          future: _getMainRecipeImage,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.fill,
                                  width: 130,
                                  height: 130,
                                ),
                              );
                            }
                            return Shimmer.fromColors(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 130,
                                  height: 130,
                                ),
                                baseColor:
                                    ColorsCustom.lightGrey.withOpacity(0.3),
                                highlightColor: ColorsCustom.background);
                          })
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorsCustom.darkGrey,
                        fontSize: 17),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatTime(item.time),
                        style: TextStyle(
                            color: ColorsCustom.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      Text(
                        item.rating < 10
                            ? "0.${item.rating}"
                            : item.rating.toString().substring(0, 1) +
                                "." +
                                item.rating.toString().substring(1),
                        style: TextStyle(color: ColorsCustom.grey),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogOutDialog extends ConsumerStatefulWidget {
  const LogOutDialog({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogOutDialogState();
}

class _LogOutDialogState extends ConsumerState<LogOutDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(FontAwesomeIcons.envelope),
      title: Text(
        AuthService.currentMail(),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text("You are going to log out."),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FutureBuilder(
                future: FirestoreServices().isAdmin(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container();
                  }
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data!) {
                    debugPrint("seems to work");
                    return TextButton(
                      child: Text("Add Recipe"),
                      onPressed: () {
                        RouterServices.router.pop();
                        RouterServices.router.pushNamed("addRecipe");
                      },
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.active) {
                    return Container();
                  }
                  return Container();
                }),
            TextButton(
                onPressed: () {
                  RouterServices.router.pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: ColorsCustom.grey),
                )),
            TextButton(
                onPressed: () {
                  AuthService.logOut();
                  ref.read(loggedInProvider.notifier).state = false;
                  RouterServices.router.pop();
                },
                child: Text(
                  "Log Out",
                  style: TextStyle(color: Colors.red),
                )),
          ],
        ),
      ],
    );
  }
}
