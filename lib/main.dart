import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/services/router.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp.router(
        theme: ThemeData(
            colorScheme: ColorScheme.light(
          primary: Colors.green,
        )),
        routerConfig: RouterServices.router,
      ),
    );
  }
}
