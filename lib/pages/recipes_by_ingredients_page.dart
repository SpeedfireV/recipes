import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sports/models/ingredient.dart';
import 'package:sports/pages/login_page.dart';
import 'package:sports/pages/recipes_page.dart';
import 'package:sports/services/add_recipe_page.dart';
import 'package:sports/services/router.dart';
import 'package:sports/widgets/page_title.dart';

import '../models/food_item.dart';
import '../models/recipe.dart';
import '../services/recipes_page.dart';

class RecipesByIngredientsPage extends StatefulHookConsumerWidget {
  const RecipesByIngredientsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipesByIngredientsPageState();
}

class _RecipesByIngredientsPageState
    extends ConsumerState<RecipesByIngredientsPage> {
  @override
  Widget build(BuildContext context) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final recipes = ref.watch(recipesProvider);
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedIconButton(
                    function: () {
                      RouterServices.router.pop();
                    },
                    icon: Icons.arrow_back),
                const PageTitle("Found Recipes"),
                OutlinedIconButton(
                    function: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ProviderScope(
                              parent: ProviderScope.containerOf(context),
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final selectedIngredients =
                                      ref.watch(selectedIngredientsProvider);
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 16),
                                        ListView(
                                          shrinkWrap: true,
                                          children: [
                                            const Center(
                                              child: PageTitle(
                                                  "Selected Ingredients"),
                                            ),
                                            const SizedBox(height: 8),
                                            ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  leading: Image.memory(
                                                      selectedIngredients
                                                          .elementAt(index)
                                                          .image,
                                                      width: 30,
                                                      height: 30),
                                                  title: Text(
                                                      selectedIngredients
                                                          .elementAt(index)
                                                          .name),
                                                );
                                              },
                                              itemCount:
                                                  selectedIngredients.length,
                                            )
                                          ],
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              RouterServices.router.pop();
                                            },
                                            child: const Text("Close"))
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          });
                    },
                    icon: FontAwesomeIcons.bowlFood),
              ],
            ),
          ),
          const SizedBox(height: 20),
          recipes.when(data: (data) {
            List<Recipe> possibleRecipes = [];

            for (Recipe recipe in data) {
              int foundIngredients = 0;
              if (recipe.ingredients.length <= selectedIngredients.length) {
                for (String ingredient in recipe.ingredients) {
                  bool ingredientNotFound = true;
                  for (Ingredient selectedIngredient in selectedIngredients) {
                    if (selectedIngredient.name == ingredient) {
                      ingredientNotFound = false;
                      break;
                    }
                  }
                  if (ingredientNotFound) {
                    break;
                  } else {
                    foundIngredients += 1;
                  }
                }
                if (foundIngredients == recipe.ingredients.length) {
                  possibleRecipes.add(recipe);
                }
              }
            }
            return possibleRecipes.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                        itemCount: possibleRecipes.length,
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
                              possibleRecipes.elementAt(index);
                          return FoodItemElement(
                              item: FoodItem(
                                  name: currentRecipe.name,
                                  description: currentRecipe.description,
                                  category: currentRecipe.category,
                                  rating: 45,
                                  time: currentRecipe.estimatedTime,
                                  ingredients: currentRecipe.ingredients,
                                  recipe: currentRecipe.recipe));
                        }),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Recipes Were Found",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ],
                  );
          }, error: (error, stackTrace) {
            return Text("Error due to $error");
          }, loading: () {
            return const Text("Loading");
          })
        ],
      ),
    );
  }
}
