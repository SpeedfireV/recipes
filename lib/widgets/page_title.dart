import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
    );
  }
}
