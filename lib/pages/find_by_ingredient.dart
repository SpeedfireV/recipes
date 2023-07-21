import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/models/ingredient.dart';
import 'package:sports/services/add_ingredient.dart';
import 'package:sports/services/ingredients_page.dart';
import 'package:sports/services/router.dart';
import 'package:sports/widgets/elevated_button.dart';
import 'package:sports/widgets/page_title.dart';

import '../services/add_recipe_page.dart';

class ByIngredientPage extends StatefulHookConsumerWidget {
  const ByIngredientPage({super.key, this.text, this.findRecipe});
  final String? text;
  final bool? findRecipe;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ByIngredientPageState();
}

class _ByIngredientPageState extends ConsumerState<ByIngredientPage> {
  @override
  Widget build(BuildContext context) {
    String ingredientsSearch = ref.watch(searchProvider);
    List<Ingredient> selectedIngredients =
        ref.watch(selectedIngredientsProvider);
    final ingredients = ref.watch(ingredientsStreamProvider);
    final isAdmin = ref.watch(adminProvider);
    return widget.findRecipe == true
        ? Scaffold(
            backgroundColor: ColorsCustom.background,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  RouterServices.router.pop();
                },
              ),
              title: SearchBar(
                onChanged: (value) {
                  ref.read(searchProvider.notifier).state = value;
                },
                hintText: "Find Your Ingredients",
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.search,
                    color: ColorsCustom.darkGrey,
                  ),
                ),
              ),
              toolbarHeight: 80,
            ),
            body: Stack(children: [
              ListView(
                children: [
                  ingredients.when(
                      data: (data) => ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                  future: data.elementAt(index),
                                  builder: (context, snapshot) {
                                    ref.watch(selectedIngredientsProvider);
                                    if (snapshot.hasError) {
                                      return const Text("Error!!!");
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                          baseColor: ColorsCustom.lightGrey
                                              .withOpacity(0.3),
                                          highlightColor:
                                              ColorsCustom.background,
                                          child: Container(
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                            ),
                                          ));
                                    }
                                    if (snapshot.hasData) {
                                      final ingredient = snapshot.data;
                                      if (ingredient != null &&
                                          ingredient.name
                                              .toLowerCase()
                                              .contains(ingredientsSearch
                                                  .toLowerCase())) {
                                        return ListTile(
                                          onTap: () {
                                            ref
                                                .read(
                                                    selectedIngredientsProvider
                                                        .notifier)
                                                .changeIngredients(ingredient);
                                          },
                                          selected: ref
                                              .read(selectedIngredientsProvider
                                                  .notifier)
                                              .ingredientExists(
                                                  ingredient.name),
                                          leading: Image.memory(
                                              ingredient.image,
                                              width: 30,
                                              height: 30),
                                          title: Text(ingredient.name),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }

                                    return Container();
                                  });
                            },
                            itemCount: data.length,
                          ),
                      error: (error, stacktrace) {
                        return const Text("Error");
                      },
                      loading: () => Container()),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, bottom: 16, right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        selectedIngredients.isEmpty
                            ? Container()
                            : CustomElevatedButton(
                                function: () {
                                  ref.watch(selectedIngredientsProvider);
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ProviderScope(
                                          parent: ProviderScope.containerOf(
                                              context),
                                          child: Consumer(
                                            builder: (context, ref, child) {
                                              final selectedIngredients =
                                                  ref.watch(
                                                      selectedIngredientsProvider);
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const SizedBox(height: 16),
                                                    ListView(
                                                      shrinkWrap: true,
                                                      children: [
                                                        const Center(
                                                          child: PageTitle(
                                                              "Selected Ingredients"),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              leading: Image.memory(
                                                                  selectedIngredients
                                                                      .elementAt(
                                                                          index)
                                                                      .image,
                                                                  width: 30,
                                                                  height: 30),
                                                              title: Text(
                                                                  selectedIngredients
                                                                      .elementAt(
                                                                          index)
                                                                      .name),
                                                              trailing:
                                                                  IconButton(
                                                                icon: Icon(
                                                                  FontAwesomeIcons
                                                                      .minus,
                                                                  color:
                                                                      ColorsCustom
                                                                          .error,
                                                                ),
                                                                onPressed: () {
                                                                  if (selectedIngredients
                                                                          .length ==
                                                                      1) {
                                                                    ref
                                                                        .read(selectedIngredientsProvider
                                                                            .notifier)
                                                                        .changeIngredients(
                                                                            selectedIngredients.elementAt(index));

                                                                    RouterServices
                                                                        .router
                                                                        .pop();
                                                                  } else {
                                                                    ref
                                                                        .read(selectedIngredientsProvider
                                                                            .notifier)
                                                                        .changeIngredients(
                                                                            selectedIngredients.elementAt(index));
                                                                  }
                                                                },
                                                              ),
                                                            );
                                                          },
                                                          itemCount:
                                                              selectedIngredients
                                                                  .length,
                                                        )
                                                      ],
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          RouterServices.router
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text("Close"))
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      });
                                },
                                text: widget.text ??
                                    "Selected ${selectedIngredients.length} ${selectedIngredients.length == 1 ? 'ingredient' : 'ingredients'}",
                                disabled: selectedIngredients.isEmpty,
                              ),
                        const SizedBox(height: 10),
                        CustomElevatedButton(
                          function: () {
                            ref
                                .read(ingredientsSelectedProvider.notifier)
                                .state = true;
                            RouterServices.router
                                .pushNamed("recipeByIngredients");
                          },
                          text: widget.text ?? "Search For Recipes",
                          icon: Icons.search,
                          disabled: selectedIngredients.isEmpty,
                        ),
                      ],
                    ),
                  ))
            ]),
          )
        : Scaffold(
            backgroundColor: ColorsCustom.background,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  RouterServices.router.pop();
                },
              ),
              title: SearchBar(
                onChanged: (value) {
                  ref.read(searchProvider.notifier).state = value;
                },
                hintText: "Find Your Ingredients",
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.search,
                    color: ColorsCustom.darkGrey,
                  ),
                ),
              ),
              toolbarHeight: 80,
            ),
            body: Stack(children: [
              ListView(
                children: [
                  isAdmin.when(
                    data: (data) {
                      return ListTile(
                        onTap: () {
                          RouterServices.router.pushNamed("addIngredient");
                        },
                        title: const Text("Add Ingredient"),
                        leading: const Icon(
                          FontAwesomeIcons.plus,
                          size: 30,
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      return Text("Error due to $error");
                    },
                    loading: () {
                      return const Text("Loading");
                    },
                  ),
                  ingredients.when(
                      data: (data) => ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                  future: data.elementAt(index),
                                  builder: (context, snapshot) {
                                    ref.watch(selectedIngredientsProvider);
                                    if (snapshot.hasError) {
                                      return const Text("Error!!!");
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text("Loading");
                                    }
                                    if (snapshot.hasData) {
                                      debugPrint(
                                          "Snapshot has data! && ${snapshot.data}!!!");
                                      final ingredient = snapshot.data!;
                                      return ListTile(
                                        onTap: () {
                                          if (ref
                                              .read(selectedIngredientsProvider
                                                  .notifier)
                                              .ingredientExists(
                                                  ingredient.name)) {
                                            ref
                                                .read(
                                                    selectedIngredientsProvider
                                                        .notifier)
                                                .deleteIngredient(
                                                    ingredient.name);
                                          } else {
                                            ref
                                                .read(
                                                    selectedIngredientsProvider
                                                        .notifier)
                                                .addIngredient(ingredient);
                                          }
                                        },
                                        selected: ref
                                            .read(selectedIngredientsProvider
                                                .notifier)
                                            .ingredientExists(ingredient.name),
                                        leading: Image.memory(ingredient.image,
                                            width: 30, height: 30),
                                        title: Text(ingredient.name),
                                      );
                                    }

                                    return Container();
                                  });
                            },
                            itemCount: data.length,
                          ),
                      error: (error, stacktrace) {
                        return const Text("Error");
                      },
                      loading: () => Container()),
                ],
              ),
              widget.text == null
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, bottom: 16, right: 16),
                        child: CustomElevatedButton(
                          icon: Icons.search,
                          function: () {
                            RouterServices.router.pop();
                          },
                          text: "Search For Recipes",
                          disabled: selectedIngredients.isEmpty,
                        ),
                      ))
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, bottom: 16, right: 16),
                        child: CustomElevatedButton(
                          function: () {
                            ref
                                .read(ingredientsSelectedProvider.notifier)
                                .state = true;
                            RouterServices.router.pop();
                          },
                          text: widget.text!,
                          disabled: selectedIngredients.isEmpty,
                        ),
                      ))
            ]),
          );
  }
}
