import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sports/services/ingredients_page.dart';
import 'package:sports/services/router.dart';

import '../constants/colors.dart';

class PickerPage extends StatefulHookConsumerWidget {
  const PickerPage(this.controller, this.hintText, {super.key});
  final TextEditingController controller;
  final String hintText;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PickerPageState();
}

class _PickerPageState extends ConsumerState<PickerPage> {
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
          onChanged: (value) {
            ref.read(searchProvider.notifier).state = value;
          },
          hintText: widget.hintText,
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
              widget.controller.text = "Category $index";
              RouterServices.router.pop();
              // TODO: Category
            },
            selected: false,
            leading: Icon(FontAwesomeIcons.burger),
            title: Text("Category $index"),
          ),
          itemCount: 5,
        ),
      ]),
    );
  }
}
