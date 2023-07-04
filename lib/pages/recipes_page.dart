import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/constants/images.dart';
import 'package:sports/functions/time.dart';
import 'package:sports/models/food_item.dart';
import 'package:sports/pages/login_page.dart';
import 'package:sports/services/router.dart';

class RecipesPage extends ConsumerStatefulWidget {
  const RecipesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecipesPageState();
}

class _RecipesPageState extends ConsumerState<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: ListView(
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(FontAwesomeIcons.barsStaggered)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: OutlinedIconButton(
                          function: () {}, icon: FontAwesomeIcons.user),
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
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton.icon(
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24))),
                                alignment: Alignment.centerLeft,
                                minimumSize: const MaterialStatePropertyAll(
                                    Size(0, 60))),
                            onPressed: () {},
                            icon: const Padding(
                              padding: EdgeInsets.only(right: 8, left: 8),
                              child: Icon(
                                FontAwesomeIcons.utensils,
                                size: 28,
                              ),
                            ),
                            label: const Text(
                              "Find Dish By Ingredients",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17),
                            ),
                          ))
                        ],
                      ),
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
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => CategoryButton(
                              text: ["All", "Breakfast"].elementAt(index),
                              activated: index.remainder(2) == 0,
                              index: index),
                          itemCount: 2,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 5 / 6,
                        children: [
                          FoodItemElement(
                              item: FoodItem(
                                  name: "Bacon & Eggs",
                                  description:
                                      "Ut cillum occaecat ad veniam magna cupidatat duis culpa duis consequat esse do. Irure nostrud consectetur occaecat proident ex duis elit sunt culpa ut dolor. Aliquip sint cupidatat ut et enim sunt exercitation proident aliqua tempor. Culpa adipisicing non qui id. In magna sunt exercitation amet id dolor ad id. Ex anim anim eu cupidatat anim et. Irure ea ipsum culpa commodo sit ad voluptate aliquip eiusmod dolor excepteur quis.",
                                  category: "breakfast",
                                  image: Images.baconEggs,
                                  rating: 45,
                                  time: 1800,
                                  ingredients: [
                                "Find a Pan",
                                "Crack an egg",
                                "Fry the bacon"
                              ],
                                  steps: [
                                "Bacon",
                                "2 Eggs",
                                "Oil"
                              ])),
                          FoodItemElement(
                              item: FoodItem(
                                  name: "Bacon & Eggs",
                                  description: "Delicious",
                                  category: "breakfast",
                                  image: Images.baconEggs,
                                  rating: 45,
                                  time: 900,
                                  ingredients: [],
                                  steps: [])),
                          FoodItemElement(
                              item: FoodItem(
                                  name: "Bacon & Eggs",
                                  description: "Delicious",
                                  category: "breakfast",
                                  image: Images.baconEggs,
                                  rating: 45,
                                  time: 900,
                                  ingredients: [],
                                  steps: [])),
                          FoodItemElement(
                              item: FoodItem(
                                  name: "Bacon & Eggs",
                                  description: "Delicious",
                                  category: "breakfast",
                                  image: Images.baconEggs,
                                  rating: 45,
                                  time: 900,
                                  ingredients: [],
                                  steps: [])),
                        ],
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "See All",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )),
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
      required this.index});
  final String text;
  final bool activated;
  final int index;

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
        onPressed: () {},
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
                      Image(width: 120, image: AssetImage(item.image)),
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
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.green[800],
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
