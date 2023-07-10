import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/services/ingredients_page.dart';
import 'package:sports/services/router.dart';
import 'package:sports/widgets/elevated_button.dart';

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
        ListView.builder(
          shrinkWrap: false,
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              debugPrint(selectedIngredients.toString());
              ref
                  .read(selectedIngredientsProvider.notifier)
                  .addIngredient(index.toString());
            },
            selected: false,
            leading: Icon(FontAwesomeIcons.burger),
            title: Text("Name"),
          ),
          itemCount: 5,
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
                    disabled: selectedIngredients.isEmpty,
                  ),
                ))
            : Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, bottom: 16, right: 16),
                  child: CustomElevatedButton(
                    function: () {
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
