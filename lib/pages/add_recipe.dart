import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/pages/login_page.dart';
import 'package:sports/services/router.dart';
import 'package:sports/widgets/elevated_button.dart';

import '../constants/styles.dart';

class AddRecipePage extends StatefulHookConsumerWidget {
  const AddRecipePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends ConsumerState<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nameNode = useFocusNode();
    final descriptionNode = useFocusNode();
    final timeNode = useFocusNode();
    final categoryNode = useFocusNode();
    final ingredientsNode = useFocusNode();
    final recipeNode = useFocusNode();
    return Scaffold(
      backgroundColor: ColorsCustom.background,
      body: Form(
        key: _formKey,
        child: Stack(children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 24),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    OutlinedIconButton(
                        function: () {
                          RouterServices.router.pop();
                        },
                        icon: Icons.arrow_back),
                    SizedBox(
                      width: 32,
                    ),
                    Text(
                      "Add Recipe",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    TextFormField(
                      key: _nameKey,
                      focusNode: nameNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Provide a Name";
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        nameNode.nextFocus();
                      },
                      decoration: InputDecoration(
                        label: Text("Name", style: Styles.inputStyle),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      focusNode: recipeNode,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Provide a Time";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text("Recipe Description",
                            style: Styles.inputStyle),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      focusNode: descriptionNode,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Provide a Description";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text("Description", style: Styles.inputStyle),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: TextFormField(
                            focusNode: timeNode,
                            onTap: () async {
                              await showDurationPicker(
                                  context: context,
                                  initialTime: Duration(seconds: 10));
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Provide a Time";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                label: Text("Estimated Time",
                                    style: Styles.inputStyle),
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.schedule)),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 6,
                          child: TextFormField(
                            focusNode: categoryNode,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Choose Category";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                label:
                                    Text("Category", style: Styles.inputStyle),
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.category_outlined)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    OutlinedIconButton(
                      function: () {},
                      icon: Icons.image,
                      text: "Select Ingredients",
                    ),
                    SizedBox(height: 10),
                    OutlinedIconButton(
                      function: () {},
                      icon: Icons.image,
                      text: "Select Images",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 90)
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16, right: 16),
              child: CustomElevatedButton(
                text: "Add Recipe",
                function: () {
                  _formKey.currentState!.validate();
                },
                icon: Icons.add,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
