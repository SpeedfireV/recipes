import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/pages/login_page.dart';
import 'package:sports/services/router.dart';
import 'package:sports/widgets/elevated_button.dart';

class ByIngredientPage extends StatefulHookConsumerWidget {
  const ByIngredientPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ByIngredientPageState();
}

class _ByIngredientPageState extends ConsumerState<ByIngredientPage> {
  @override
  Widget build(BuildContext context) {
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
          shrinkWrap: true,
          itemBuilder: (context, index) => ListTile(
            onTap: () {},
            selected: false,
            leading: Icon(FontAwesomeIcons.burger),
            title: Text("Name"),
          ),
          itemCount: 5,
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16, right: 16),
              child: CustomElevatedButton(
                icon: Icons.search,
                function: () {},
                text: "Search For Recipes",
              ),
            ))
      ]),
    );
  }
}
