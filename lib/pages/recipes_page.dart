import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/functions/time.dart';
import 'package:sports/models/food_item.dart';
import 'package:sports/pages/login_page.dart';
import 'package:sports/services/add_recipe_page.dart';
import 'package:sports/services/auth.dart';
import 'package:sports/services/category_picker.dart';
import 'package:sports/services/firebase.dart';
import 'package:sports/services/item_page.dart';
import 'package:sports/services/recipes_page.dart';
import 'package:sports/services/router.dart';
import 'package:sports/widgets/problem_snackbar.dart';

import '../widgets/elevated_button.dart';

class RecipesPage extends StatefulHookConsumerWidget {
  const RecipesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecipesPageState();
}

class _RecipesPageState extends ConsumerState<RecipesPage> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      ref.read(scrollPositionProvider.notifier).state =
          scrollController.position.pixels.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool loggedIn = ref.watch(loggedInProvider);
    final recipes = ref.watch(recipesProvider);
    final categories = ref.watch(categoriesProvider);
    final categoryFilter = ref.watch(categoryFilterProvider);
    final scrollPosition = ref.watch(scrollPositionProvider);

    return Scaffold(
        floatingActionButton: scrollPosition > 70
            ? FloatingActionButton(
                backgroundColor: ColorsCustom.green,
                onPressed: () {
                  scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: const Icon(Icons.arrow_upward_rounded),
              )
            : null,
        drawer: const Drawer(child: Text("Working")),
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
                                  builder: (context) => const LogOutDialog());
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
                          function: () {
                            if (AuthService.loggedIn()) {
                              ref
                                  .read(selectedIngredientsProvider.notifier)
                                  .clearIngredients();
                              RouterServices.router.pushNamed("ingredients",
                                  extra: {"getRecipe": true});
                            } else {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              showProblemSnackbar(
                                  "You have to log in to use this fuction",
                                  context);
                            }
                          },
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
                            error: (error, stackTrace) => const Text("Error"),
                            loading: () {
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Shimmer.fromColors(
                                      baseColor: ColorsCustom.lightGrey
                                          .withOpacity(0.3),
                                      highlightColor: ColorsCustom.background,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(24)),
                                        width: 140,
                                        height: 50,
                                      ));
                                },
                                itemCount: 4,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 12),
                              );
                            }),
                      ),
                      const SizedBox(height: 20),
                      recipes.when(data: (data) {
                        if (categoryFilter == "All") {
                          return GridView.builder(
                              itemCount: data.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 6 / 7,
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                final currentRecipe = data.elementAt(index);
                                return FoodItemElement(
                                    item: FoodItem(
                                        name: currentRecipe.name,
                                        description: currentRecipe.description,
                                        category: currentRecipe.category,
                                        rating: 45,
                                        time: currentRecipe.estimatedTime,
                                        ingredients: currentRecipe.ingredients,
                                        recipe: currentRecipe.recipe));
                              });
                        } else {
                          final filteredItems = data.where(
                              (element) => element.category == categoryFilter);
                          return GridView.builder(
                              itemCount: filteredItems.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
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
                                        description: currentRecipe.description,
                                        category: currentRecipe.category,
                                        rating: 45,
                                        time: currentRecipe.estimatedTime,
                                        ingredients: currentRecipe.ingredients,
                                        recipe: currentRecipe.recipe));
                              });
                        }
                      }, error: (error, errorStack) {
                        return const Text("data");
                      }, loading: () {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 6 / 7,
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                                baseColor:
                                    ColorsCustom.lightGrey.withOpacity(0.3),
                                highlightColor: ColorsCustom.background,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                ));
                          },
                          itemCount: 4,
                        );
                      }),
                      const SizedBox(height: 80)
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
    final recipeMainImage = ref.watch(recipeMainImageProvider(item.name));
    return InkWell(
        onTap: () {
          RouterServices.router.pushNamed("recipe", extra: item);
        },
        child: Ink(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 2),
                    color: ColorsCustom.lightGrey.withOpacity(0.9),
                    blurRadius: 3)
              ]),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: recipeMainImage.when(
                            skipLoadingOnReload: false,
                            data: (data) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Hero(
                                  tag: item.name,
                                  child: Image.memory(
                                    data!,
                                    fit: BoxFit.fill,
                                    width: 130,
                                    height: 130,
                                  ),
                                ),
                              );
                            },
                            loading: () {
                              return Shimmer.fromColors(
                                  baseColor:
                                      ColorsCustom.lightGrey.withOpacity(0.3),
                                  highlightColor: ColorsCustom.background,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: 130,
                                    height: 130,
                                  ));
                            },
                            error: (error, stackTrace) {
                              return Text("Error due to $error");
                            },
                          ))
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
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: const Icon(FontAwesomeIcons.envelope),
      title: Text(
        AuthService.currentMail()!,
      ),
      content: const Padding(
        padding: EdgeInsets.only(top: 8.0),
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
                      child: const Text("Add Recipe"),
                      onPressed: () {
                        RouterServices.router.pop();
                        ref
                            .read(selectedIngredientsProvider.notifier)
                            .clearIngredients();
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
                child: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.red),
                )),
          ],
        ),
      ],
    );
  }
}
