import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/functions/time.dart';
import 'package:sports/models/food_item.dart';
import 'package:sports/pages/login_page.dart';
import 'package:sports/services/firebase.dart';
import 'package:sports/services/item_page.dart';
import 'package:sports/services/router.dart';

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
    return Scaffold(
      backgroundColor: ColorsCustom.background,
      body: ListView(
        children: [
          SizedBox(height: 16),
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
                    OutlinedIconButton(
                      function: () {},
                      icon: Icons.favorite,
                      color: Colors.green[700]!,
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FutureBuilder(
                        future: StorageServices().getRecipeImages(item.name),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                    height: 240,
                                    child: Stack(
                                      children: [
                                        CarouselSlider.builder(
                                          itemBuilder:
                                              (context, index, realIndex) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.memory(
                                                snapshot.data!.elementAt(index),
                                                width: 240,
                                                height: 240,
                                                fit: BoxFit.fill,
                                              ),
                                            );
                                          },
                                          options: CarouselOptions(
                                              onPageChanged:
                                                  (newValue, reason) {
                                                ref
                                                    .read(imagePositionProvider
                                                        .notifier)
                                                    .state = (newValue).toInt();
                                              },
                                              enableInfiniteScroll: false),
                                          itemCount: snapshot.data!.length,
                                        ),
                                      ],
                                    )),
                                SizedBox(height: 8),
                                AnimatedSmoothIndicator(
                                  activeIndex: imagePosition,
                                  count: snapshot.data!.length,
                                  effect: WormEffect(
                                      activeDotColor: Colors.green[800]!),
                                )
                              ],
                            );
                          }
                          return Shimmer.fromColors(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                width: 240,
                                height: 240,
                              ),
                              baseColor:
                                  ColorsCustom.lightGrey.withOpacity(0.3),
                              highlightColor: ColorsCustom.background);
                          ;
                        })),
              ),
            ],
          ),
          SizedBox(height: 30),
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
                    SizedBox(width: 2),
                    Text(
                      formatTime(item.time),
                      style: TextStyle(color: ColorsCustom.grey),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.star,
                      color: ColorsCustom.lightGreen,
                    ),
                    SizedBox(width: 2),
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
              SizedBox(width: 20),
              CategoryTabSelector(
                  index: 1, currentIndex: currentTab, title: "Ingredients"),
              SizedBox(width: 20),
              CategoryTabSelector(
                  index: 2, currentIndex: currentTab, title: "Recipe")
            ],
          ),
          SizedBox(height: 16),
          FoodItemDescription(
              index: currentTab,
              description: item.description,
              recipe: item.recipe,
              ingredients: item.ingredients)
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
          padding: EdgeInsets.only(bottom: 4),
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
      required this.ingredients});
  final int index;
  final String description;
  final String recipe;
  final List<String> ingredients;

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
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ingredients.length,
              itemBuilder: (context, index) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            ingredients[index],
                            style: TextStyle(
                                color: ColorsCustom.grey, fontSize: 16),
                          )
                        ],
                      ),
                      Divider(
                        color: ColorsCustom.lightGrey,
                        thickness: 1,
                      )
                    ],
                  )),
        );
      case 2:
        {
          LineSplitter ls = LineSplitter();
          List<String> steps = ls.convert(recipe);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: steps.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
                      SizedBox(width: 40),
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
