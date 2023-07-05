import 'package:hive_flutter/hive_flutter.dart';

class DatabaseServices {
  static Future addToBox() async {
    Box box = Hive.box("launch");
    box.add(true);
  }

  static bool appLaunched() {
    Box box = Hive.box("launch");
    if (box.values.length == 1) {
      return true;
    } else {
      return false;
    }
  }
}
