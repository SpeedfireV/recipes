import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/services/add_ingredient.dart';
import 'package:sports/services/auth.dart';
import 'package:sports/services/firebase.dart';
import 'package:sports/services/ingredients_page.dart';
import 'package:sports/services/router.dart';
import 'package:sports/widgets/elevated_button.dart';

import '../models/ingredient.dart';
import '../services/add_recipe_page.dart';

class ByIngredientPage extends StatefulHookConsumerWidget {
  const ByIngredientPage({super.key, this.text});
  final String? text;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ByIngredientPageState();
}

class _ByIngredientPageState extends ConsumerState<ByIngredientPage> {
  @override
  Widget build(BuildContext context) {
    String ingredientsSearch = ref.watch(searchProvider);
    List selectedIngredients = ref.watch(selectedIngredientsProvider);
    final ingredients = ref.watch(ingredientsStreamProvider);
    final isAdmin = ref.watch(adminProvider);
    return Scaffold(
      backgroundColor: ColorsCustom.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                  title: Text("Add Ingredient"),
                  leading: Icon(
                    FontAwesomeIcons.plus,
                    size: 30,
                  ),
                );
              },
              error: (error, stackTrace) {
                return Text("Error due to $error");
              },
              loading: () {
                return Text("Loading");
              },
            ),
            ingredients.when(
                data: (data) => ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                            future: data.elementAt(index),
                            builder: (context, snapshot) {
                              List selectedIngredients =
                                  ref.watch(selectedIngredientsProvider);
                              if (snapshot.hasError) {
                                return Text("Error!!!");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Loading");
                              }
                              if (snapshot.hasData) {
                                debugPrint("Snapshot has data!");
                                final ingredient = snapshot.data!;
                                return ListTile(
                                  onTap: () {
                                    if (ref
                                        .read(selectedIngredientsProvider
                                            .notifier)
                                        .ingredientExists(ingredient.name)) {
                                      ref
                                          .read(selectedIngredientsProvider
                                              .notifier)
                                          .deleteIngredient(ingredient.name);
                                    } else {
                                      ref
                                          .read(selectedIngredientsProvider
                                              .notifier)
                                          .addIngredient(ingredient);
                                    }
                                  },
                                  selected: ref
                                      .read(
                                          selectedIngredientsProvider.notifier)
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
                  return Text("Error");
                },
                loading: () => Container()),
          ],
        ),
        widget.text == null
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, bottom: 16, right: 16),
                  child: CustomElevatedButton(
                    icon: Icons.search,
                    function: () {
                      RouterServices.router.pop();
                    },
                    text: "Search For Recipes",
                    disabled: selectedIngredients.length == 0,
                  ),
                ))
            : Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, bottom: 16, right: 16),
                  child: CustomElevatedButton(
                    function: () {
                      ref.read(ingredientsSelectedProvider.notifier).state =
                          true;
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
