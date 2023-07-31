import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/functions/time.dart';
import 'package:sports/models/food_item.dart';
import 'package:sports/pages/login_page.dart';
import 'package:sports/services/item_page.dart';
import 'package:sports/services/local_database.dart';
import 'package:sports/services/router.dart';
import 'package:sports/widgets/problem_snackbar.dart';

class RecipePage extends StatefulHookConsumerWidget {
  const RecipePage({super.key, required this.item});
  final FoodItem item;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecipePageState();
}

class _RecipePageState extends ConsumerState<RecipePage> {
  @override
  Widget build(BuildContext context) {
    int currentTab = ref.watch(tabSelectorProvider);
    int imagePosition = ref.watch(imagePositionProvider);
    FoodItem item = widget.item;
    final likedStream = ref.watch(likedStreamProvider);
    final recipeImages = ref.watch(recipeImagesProvider(item.name));
    return Scaffold(
      backgroundColor: ColorsCustom.background,
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedIconButton(
                      function: () {
                        RouterServices.router.pop();
                      },
                      icon: Icons.arrow_back,
                      color: ColorsCustom.darkGrey,
                    ),
                    likedStream.when(
                      data: (data) {
                        List<dynamic> likedList =
                            data.data()!["liked"] as List<dynamic>;
                        return OutlinedIconButton(
                          function: () async {
                            late bool isLoggedIn;
                            if (likedList.contains(item.name)) {
                              isLoggedIn = await ref
                                  .read(likedStreamProvider.notifier)
                                  .unlikeRecipe(item.name);
                            } else {
                              isLoggedIn = await ref
                                  .read(likedStreamProvider.notifier)
                                  .likeRecipe(item.name);
                            }

                            if (!isLoggedIn) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              showProblemSnackbar(
                                  "You Must Log In To Like", context);
                            }
                          },
                          icon: likedList.contains(item.name)
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_rounded,
                          color: Colors.green[700]!,
                        );
                      },
                      loading: () {
                        return OutlinedIconButton(
                          function: () async {
                            bool isLoggedIn = await ref
                                .read(likedStreamProvider.notifier)
                                .likeRecipe(item.name);
                            if (!isLoggedIn) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              showProblemSnackbar(
                                  "You Must Log In To Like", context);
                            }
                          },
                          icon: Icons.favorite_outline_rounded,
                          color: Colors.green[700]!,
                        );
                      },
                      error: (error, stackTrace) {
                        debugPrint("Error due to $error");
                        return Text("Error due to $error");
                      },
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: recipeImages.when(data: (data) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              height: 240,
                              child: Stack(
                                children: [
                                  CarouselSlider.builder(
                                    itemBuilder: (context, index, realIndex) {
                                      if (index == 0) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.memory(
                                            LocalDatabaseServices()
                                                .getRecipeImage(item.name)!,
                                            width: 240,
                                            height: 240,
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                      }
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Hero(
                                          tag: item.name,
                                          child: Image.memory(
                                            data.elementAt(index - 1),
                                            width: 240,
                                            height: 240,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                        onPageChanged: (newValue, reason) {
                                          ref
                                              .read(imagePositionProvider
                                                  .notifier)
                                              .state = (newValue).toInt();
                                        },
                                        enableInfiniteScroll: false),
                                    itemCount: data.length + 1,
                                  ),
                                ],
                              )),
                          const SizedBox(height: 8),
                          AnimatedSmoothIndicator(
                            activeIndex: imagePosition,
                            count: data.length + 1,
                            effect:
                                WormEffect(activeDotColor: Colors.green[800]!),
                          )
                        ],
                      );
                    }, error: (error, errorStack) {
                      return Text("Error due to $error");
                    }, loading: () {
                      return Shimmer.fromColors(
                          baseColor: ColorsCustom.lightGrey.withOpacity(0.3),
                          highlightColor: ColorsCustom.background,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            width: 240,
                            height: 240,
                          ));
                    })),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: ColorsCustom.darkGrey),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule,
                      color: ColorsCustom.lightGreen,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      formatTime(item.time),
                      style: TextStyle(color: ColorsCustom.grey),
                    )
                  ],
                )
              ],
            ),
          ),
          Divider(
            indent: 16,
            endIndent: 16,
            thickness: 1,
            color: ColorsCustom.lightGrey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryTabSelector(
                  index: 0, currentIndex: currentTab, title: "Details"),
              const SizedBox(width: 20),
              CategoryTabSelector(
                  index: 1, currentIndex: currentTab, title: "Ingredients"),
              const SizedBox(width: 20),
              CategoryTabSelector(
                  index: 2, currentIndex: currentTab, title: "Recipe")
            ],
          ),
          const SizedBox(height: 16),
          FoodItemDescription(
            index: currentTab,
            description: item.description,
            recipe: item.recipe,
            ingredients: item.ingredients,
            recipeName: item.name,
          )
        ],
      ),
    );
  }
}

class CategoryTabSelector extends ConsumerStatefulWidget {
  const CategoryTabSelector(
      {super.key,
      required this.index,
      required this.currentIndex,
      required this.title});
  final int index;
  final int currentIndex;
  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryTabSelectorState();
}

class _CategoryTabSelectorState extends ConsumerState<CategoryTabSelector> {
  @override
  Widget build(BuildContext context) {
    bool active = widget.index == widget.currentIndex;

    return InkWell(
      onTap: () {
        ref.read(tabSelectorProvider.notifier).state = widget.index;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        child: Ink(
          padding: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
              border: active
                  ? Border(bottom: BorderSide(color: ColorsCustom.green))
                  : null),
          child: Text(
            widget.title,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: active ? ColorsCustom.darkGrey : ColorsCustom.grey),
          ),
        ),
      ),
    );
  }
}

class FoodItemDescription extends ConsumerWidget {
  const FoodItemDescription(
      {super.key,
      required this.index,
      required this.description,
      required this.recipe,
      required this.ingredients,
      required this.recipeName});
  final int index;
  final String description;
  final String recipe;
  final List<String> ingredients;
  final String recipeName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (index) {
      case 0:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            description,
            style: TextStyle(color: ColorsCustom.darkGrey, fontSize: 16),
          ),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredientImage = ref.watch(
                    itemPageIngredientImageProvider(
                        ingredients.elementAt(index)));

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        LocalDatabaseServices().getIngredientImage(
                                    ingredients.elementAt(index)) !=
                                null
                            ? Row(
                                children: [
                                  Image.memory(
                                    LocalDatabaseServices().getIngredientImage(
                                        ingredients.elementAt(index))!,
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 8)
                                ],
                              )
                            : ingredientImage.when(
                                data: (data) {
                                  if (data != null) {
                                    LocalDatabaseServices().addIngredientImage(
                                        ingredients.elementAt(index), data);
                                    return Row(
                                      children: [
                                        Image.memory(
                                          data,
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(width: 8)
                                      ],
                                    );
                                  } else {
                                    return const Text("");
                                  }
                                },
                                error: (error, stackTrace) {
                                  return Text("Error due to $error");
                                },
                                loading: () {
                                  return Shimmer.fromColors(
                                      baseColor: ColorsCustom.lightGrey
                                          .withOpacity(0.3),
                                      highlightColor: ColorsCustom.background,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: 24,
                                        height: 24,
                                      ));
                                },
                              ),
                        Text(
                          ingredients[index],
                          style:
                              TextStyle(color: ColorsCustom.grey, fontSize: 16),
                        )
                      ],
                    ),
                    Divider(
                      color: ColorsCustom.lightGrey,
                      thickness: 1,
                    )
                  ],
                );
              }),
        );
      case 2:
        {
          LineSplitter ls = const LineSplitter();
          List<String> steps = ls.convert(recipe);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: steps.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        (index + 1).toString(),
                        style: TextStyle(
                            color: ColorsCustom.darkGrey,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                      const SizedBox(width: 40),
                      Text(
                        steps[index],
                        style:
                            TextStyle(color: ColorsCustom.grey, fontSize: 16),
                      )
                    ],
                  ),
                  Divider(
                    color: ColorsCustom.lightGrey,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          );
        }
      default:
        return Container();
    }
  }
}
