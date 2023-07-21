import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sports/firebase_options.dart';
import 'package:sports/services/auth.dart';
import 'package:sports/services/firebase.dart';
import 'package:sports/services/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox("launch");
  await Hive.openBox("recipesImages");
  await Hive.openBox("ingredientsImages");
  if (AuthService.loggedIn() && !(await FirestoreServices().profileCreated())) {
    await AuthService.logOut();
  }
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        )),
        routerConfig: RouterServices.router,
      ),
    );
  }
}
