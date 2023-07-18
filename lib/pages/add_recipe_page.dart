import 'dart:io';

import 'package:duration_picker/duration_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sports/constants/colors.dart';
import 'package:sports/functions/time.dart';
import 'package:sports/models/image.dart';
import 'package:sports/models/recipe.dart';
import 'package:sports/pages/login_page.dart';
import 'package:sports/services/add_ingredient.dart';
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

    final ingredientsSelected = ref.watch(ingredientsSelectedProvider);
    final imagesSelected = ref.watch(imagesSelectedProvider);
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
                    ingredients.length == 0
                        ? OutlinedIconButton(
                            function: () {
                              RouterServices.router.pushNamed("ingredients",
                                  extra: "Submit Ingredients");
                            },
                            icon: FontAwesomeIcons.bowlFood,
                            text: "Select Ingredients",
                            errorText: ingredientsSelected
                                ? null
                                : "Provide Ingredients",
                            borderColor:
                                ingredientsSelected ? null : ColorsCustom.error,
                          )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey[500]!, width: 2)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  "Selected Ingredients",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsCustom.darkGrey),
                                ),
                                SizedBox(height: 10),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => ListTile(
                                    leading: Image.memory(
                                      ingredients[index].image,
                                      width: 24,
                                      height: 24,
                                    ),
                                    title: Text(ingredients[index].name),
                                    trailing: IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.minus,
                                        color: ColorsCustom.error,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(selectedIngredientsProvider
                                                .notifier)
                                            .deleteIngredient(
                                                ingredients[index].name);
                                      },
                                    ),
                                  ),
                                  itemCount: ingredients.length,
                                ),
                                SizedBox(height: 10),
                                TextButton(
                                    onPressed: () {
                                      RouterServices.router.pushNamed(
                                          "ingredients",
                                          extra: "Submit Ingredients");
                                    },
                                    child: Text("Add More")),
                              ],
                            ),
                          ),
                    SizedBox(height: 10),
                    images.length == 0
                        ? OutlinedIconButton(
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
                                List<ImageWithMetadata> imagesWithMetadata = [
                                  ImageWithMetadata(
                                      image: result.files.elementAt(0),
                                      main: true),
                                ];
                                result.files.sublist(1).forEach((image) {
                                  imagesWithMetadata.add(ImageWithMetadata(
                                      image: image, main: false));
                                });
                                ref
                                    .read(selectedImagesProvider.notifier)
                                    .addImages(imagesWithMetadata);
                              }
                            },
                            icon: Icons.image,
                            text: "Select Images",
                            errorText: imagesSelected ? null : "Provide Images",
                            borderColor:
                                imagesSelected ? null : ColorsCustom.error,
                          )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey[500]!, width: 2)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  "Selected Images",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsCustom.darkGrey),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 12,
                                            crossAxisCount: 2),
                                    itemBuilder: (context, index) {
                                      debugPrint("Trying to get $index!");
                                      final imageFile = File(
                                          images.elementAt(index).image.path!);

                                      return Stack(
                                        children: [
                                          Image.memory(
                                              imageFile.readAsBytesSync()),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, right: 8),
                                            child: Align(
                                                alignment: Alignment.topRight,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Material(
                                                      elevation: 2,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (!images
                                                              .elementAt(index)
                                                              .main) {
                                                            ref
                                                                .read(selectedImagesProvider
                                                                    .notifier)
                                                                .setMainImage(images
                                                                    .elementAt(
                                                                        index)
                                                                    .image
                                                                    .name);
                                                          }
                                                        },
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Ink(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              color: ColorsCustom
                                                                  .white
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Icon(
                                                                !(images
                                                                        .elementAt(
                                                                            index)
                                                                        .main)
                                                                    ? Icons
                                                                        .star_outline
                                                                    : Icons
                                                                        .star,
                                                                color:
                                                                    ColorsCustom
                                                                        .green,
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                    SizedBox(width: 6),
                                                    Material(
                                                      elevation: 2,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        icon: Icon(
                                                                            FontAwesomeIcons.image),
                                                                        title: Text(
                                                                            "Delete Image"),
                                                                        content:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 8.0),
                                                                          child:
                                                                              Text("You are going to delete an image."),
                                                                        ),
                                                                        actions: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    RouterServices.router.pop();
                                                                                  },
                                                                                  child: Text(
                                                                                    "Cancel",
                                                                                    style: TextStyle(color: ColorsCustom.grey),
                                                                                  )),
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    ref.read(selectedImagesProvider.notifier).deleteImage(images.elementAt(index).image.name);
                                                                                    RouterServices.router.pop();
                                                                                  },
                                                                                  child: Text(
                                                                                    "Delete Image",
                                                                                    style: TextStyle(color: Colors.red),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ));
                                                        },
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Ink(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              color: ColorsCustom
                                                                  .white
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: Icon(
                                                                FontAwesomeIcons
                                                                    .xmark,
                                                                color:
                                                                    ColorsCustom
                                                                        .error,
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          )
                                        ],
                                      );
                                    },
                                    itemCount: images.length,
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextButton(
                                    onPressed: () async {
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
                                        List<ImageWithMetadata>
                                            imagesWithMetadata = [];
                                        result.files.forEach((image) {
                                          imagesWithMetadata.add(
                                              ImageWithMetadata(
                                                  image: image, main: false));
                                        });
                                        ref
                                            .read(
                                                selectedImagesProvider.notifier)
                                            .addImages(imagesWithMetadata);
                                      }
                                    },
                                    child: Text("Add More")),
                              ],
                            ),
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
                      ingredients.length != 0 &&
                      images.length != 0) {
                    List<String> ingredientsName = [];
                    ingredients.forEach((element) {
                      ingredientsName.add(element.name);
                    });
                    await FirestoreServices().addRecipe(Recipe(
                        name: nameController.text,
                        recipe: recipeController.text,
                        description: descriptionController.text,
                        estimatedTime: estimatedTime,
                        category: categoryController.text,
                        ingredients: ingredientsName));

                    await StorageServices()
                        .addRecipeImages(images, nameController.text);

                    RouterServices.router.pop();
                  } else {
                    if (ingredients.length == 0) {
                      ref.read(ingredientsSelectedProvider.notifier).state =
                          false;
                    }
                    if (images.length == 0) {
                      ref.read(imagesSelectedProvider.notifier).state = false;
                    }
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
