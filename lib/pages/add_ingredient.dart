import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sports/pages/login_page.dart';
import 'package:sports/services/add_ingredient.dart';
import 'package:sports/services/firebase.dart';
import 'package:sports/services/router.dart';
import 'package:sports/widgets/elevated_button.dart';

import '../constants/colors.dart';
import '../constants/styles.dart';
import '../widgets/page_title.dart';
import '../widgets/problem_snackbar.dart';

class AddIngredientPage extends StatefulHookConsumerWidget {
  const AddIngredientPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddIngredientPageState();
}

class _AddIngredientPageState extends ConsumerState<AddIngredientPage> {
  final _categoryKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController ingredientController = useTextEditingController();
    final ingredientImage = ref.watch(ingredientImageProvider);
    final ingredientImagePicked = ref.watch(ingredientImagePickedProvider);
    return Scaffold(
        backgroundColor: ColorsCustom.background,
        body: Form(
            key: _categoryKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OutlinedIconButton(
                          function: () {
                            RouterServices.router.pop();
                          },
                          icon: Icons.arrow_back),
                      const SizedBox(
                        width: 32,
                      ),
                      const PageTitle("Add Ingredient")
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, bottom: 16, right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: ingredientController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name Ingredient";
                          }
                          return null;
                        },
                        onTap: () {
                          debugPrint("Entered Category Editor");
                        },
                        onChanged: (value) {
                          _categoryKey.currentState!.validate();
                        },
                        decoration: InputDecoration(
                          label: Text("Ingredient", style: Styles.inputStyle),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedIconButton(
                        errorText:
                            !ingredientImagePicked ? "Select an Icon" : null,
                        borderColor: !ingredientImagePicked
                            ? ColorsCustom.error
                            : ingredientImage == null
                                ? null
                                : ColorsCustom.green,
                        function: () async {
                          late FilePickerResult? result;
                          try {
                            result = await FilePicker.platform
                                .pickFiles(allowMultiple: false);
                          } on PlatformException {
                            showProblemSnackbar(
                                "You must give permission to choose files",
                                context);
                          }
                          if (result != null) {
                            CroppedFile? croppedFile = await ImageCropper()
                                .cropImage(
                                    sourcePath: result.paths.elementAt(0)!,
                                    aspectRatio: const CropAspectRatio(
                                        ratioX: 1, ratioY: 1));

                            if (croppedFile != null) {
                              File imageFile = File(croppedFile.path);
                              ref.read(ingredientImageProvider.notifier).state =
                                  imageFile;
                              ref
                                  .read(ingredientImagePickedProvider.notifier)
                                  .state = true;
                            }
                          }
                        },
                        icon: Icons.image,
                        text: "Select Icon",
                      ),
                      const SizedBox(height: 20),
                      CustomElevatedButton(
                          function: () async {
                            if (_categoryKey.currentState!.validate() &&
                                ingredientImage != null) {
                              await FirestoreServices().addIngredient(
                                  ingredientController.text, ingredientImage);

                              RouterServices.router.pop();
                            } else if (ingredientImage == null) {
                              ref
                                  .read(ingredientImagePickedProvider.notifier)
                                  .state = false;
                            }
                          },
                          text: "Add Ingredient"),
                    ],
                  ),
                ),
              ],
            )));
  }
}
