import 'dart:io';

import 'package:duration_picker/duration_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/functions/time.dart';
import 'package:sports/models/recipe.dart';
import 'package:sports/pages/login_page.dart';
import 'package:sports/services/firebase.dart';
import 'package:sports/services/router.dart';
import 'package:sports/widgets/elevated_button.dart';
import 'package:sports/widgets/page_title.dart';
import 'package:sports/widgets/problem_snackbar.dart';

import '../constants/styles.dart';
import '../services/add_recipe_page.dart';

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

    final nameController = useTextEditingController();
    final recipeController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final timeController = useTextEditingController();
    final categoryController = useTextEditingController();

    final currentCategory = ref.watch(categoryProvider);
    final ingredients = ref.watch(selectedIngredientsProvider);
    final estimatedTime = ref.watch(estimatedTimeProvider);
    final images = ref.watch(selectedImagesProvider);
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
                    PageTitle("Add Recipe")
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
                      controller: nameController,
                      key: _nameKey,
                      focusNode: nameNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Provide a Name";
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      onEditingComplete: () {
                        nameNode.nextFocus();
                      },
                      decoration: InputDecoration(
                        label: Text("Name", style: Styles.inputStyle),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: recipeController,
                      focusNode: recipeNode,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Provide a Recipe";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text("Recipe", style: Styles.inputStyle),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: descriptionController,
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      readOnly: true,
                      controller: timeController,
                      focusNode: timeNode,
                      onTap: () async {
                        Duration? time = await showDurationPicker(
                            context: context,
                            initialTime: Duration(minutes: 5));
                        if (time != null) {
                          ref.read(estimatedTimeProvider.notifier).state =
                              time.inSeconds;
                          timeController.text = formatTime(time.inSeconds);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Provide Time";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          label:
                              Text("Estimated Time", style: Styles.inputStyle),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: Icon(Icons.schedule)),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      readOnly: true,
                      focusNode: categoryNode,
                      controller: categoryController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Choose Category";
                        }
                        return null;
                      },
                      onTap: () {
                        RouterServices.router.pushNamed("category",
                            extra: [categoryController, "Find Category"]);
                        categoryController.text = "-";
                        _formKey.currentState!.validate();
                        categoryController.text = "";
                      },
                      decoration: InputDecoration(
                          label: Text("Category", style: Styles.inputStyle),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: Icon(Icons.category_outlined)),
                    ),
                    SizedBox(height: 10),
                    OutlinedIconButton(
                      function: () {
                        RouterServices.router.pushNamed("ingredients",
                            extra: "Submit Ingredients");
                      },
                      icon: FontAwesomeIcons.bowlFood,
                      text: "Select Ingredients",
                    ),
                    SizedBox(height: 10),
                    OutlinedIconButton(
                      function: () async {
                        late FilePickerResult? result;
                        try {
                          result = await FilePicker.platform
                              .pickFiles(allowMultiple: true);
                        } on PlatformException catch (e) {
                          showProblemSnackbar(
                              "You must give permission to choose files",
                              context);
                        }

                        if (result != null) {
                          ref
                              .read(selectedImagesProvider.notifier)
                              .addImages(result.files);
                        }
                      },
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
                function: () async {
                  if (_formKey.currentState!.validate() &&
                      ingredients.length != 0) {
                    await FirestoreServices()
                        .addRecipe(Recipe(
                          name: nameController.text,
                          recipe: recipeController.text,
                          description: descriptionController.text,
                          estimatedTime: estimatedTime,
                          category: categoryController.text,
                        ))
                        .then((value) {});

                    await StorageServices()
                        .addRecipeImages(images, nameController.text);

                    RouterServices.router.pop();
                    // TODO: Add Recipe
                  }
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
