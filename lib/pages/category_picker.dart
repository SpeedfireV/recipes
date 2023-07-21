import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sports/pages/login_page.dart';
import 'package:sports/services/category_picker.dart';
import 'package:sports/services/firebase.dart';
import 'package:sports/services/ingredients_page.dart';
import 'package:sports/services/router.dart';
import 'package:sports/widgets/elevated_button.dart';

import '../constants/colors.dart';
import '../constants/styles.dart';
import '../widgets/page_title.dart';

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
    final categories = ref.watch(categoriesProvider);
    final search = ref.watch(searchProvider);
    return Scaffold(
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
        ListView(
          children: [
            ListTile(
              onTap: () {
                RouterServices.router.pushNamed("addCategory");
              },
              title: const Text("Add Category"),
              leading: const Icon(Icons.add_rounded),
            ),
            categories.when(
                loading: () => Container(
                      padding: const EdgeInsets.only(top: 16),
                      height: 100,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                error: (error, stackTrace) => Text("Error $error"),
                data: (data) {
                  final filteredData = search == ""
                      ? data
                      : data.where(
                          (element) => element.toLowerCase().contains(search));
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          widget.controller.text =
                              filteredData.elementAt(index);
                          RouterServices.router.pop();
                          // TODO: Image Category
                        },
                        selected: false,
                        title: Text(filteredData.elementAt(index)),
                      );
                    },
                    itemCount: filteredData.length,
                  );
                }),
          ],
        ),
      ]),
    );
  }
}

class AddCategoryPage extends StatefulHookConsumerWidget {
  const AddCategoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddCategoryPageState();
}

class _AddCategoryPageState extends ConsumerState<AddCategoryPage> {
  final _categoryKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController categoryController = useTextEditingController();
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
                      const PageTitle("Add Recipe")
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
                        controller: categoryController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name Category";
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
                          label: Text("Category", style: Styles.inputStyle),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      /*
                      OutlinedIconButton(
                        errorText: !categoryImagePicked == true
                            ? "Select an Icon"
                            : null,
                        borderColor: categoryImagePicked == false
                            ? ColorsCustom.error
                            : categoryImage == null
                                ? null
                                : ColorsCustom.green,
                        function: () async {
                          late FilePickerResult? result;
                          try {
                            result = await FilePicker.platform
                                .pickFiles(allowMultiple: false);
                          } on PlatformException catch (e) {
                            showProblemSnackbar(
                                "You must give permission to choose files",
                                context);
                          }
                          if (result != null) {
                            CroppedFile? croppedFile = await ImageCropper()
                                .cropImage(
                                    sourcePath: result.paths.elementAt(0)!,
                                    aspectRatio:
                                        CropAspectRatio(ratioX: 1, ratioY: 1));

                            if (croppedFile != null) {
                              File imageFile = File(croppedFile!.path);
                              ref.read(categoryImageProvider.notifier).state =
                                  imageFile;
                              ref
                                  .read(categoryImagePickedProvider.notifier)
                                  .state = true;
                            }
                          }
                        },
                        icon: Icons.image,
                        text: "Select Icon",
                      ),*/
                      const SizedBox(height: 20),
                      CustomElevatedButton(
                          function: () async {
                            if (_categoryKey.currentState!.validate()) {
                              (await FirestoreServices()
                                  .addCategory(categoryController.text));

                              RouterServices.router.pop();
                            }
                          },
                          text: "Add Category"),
                    ],
                  ),
                ),
              ],
            )));
  }
}
