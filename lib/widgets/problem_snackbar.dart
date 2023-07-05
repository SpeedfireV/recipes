import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/colors.dart';

showProblemSnackbar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: ColorsCustom.darkGrey,
    content: ProblemSnackbar(text: text),
  ));
}

class ProblemSnackbar extends ConsumerWidget {
  const ProblemSnackbar({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: ColorsCustom.white),
      ),
    );
  }
}
