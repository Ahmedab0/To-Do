import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// #1
class ThemeServices {
  final GetStorage _box = GetStorage();
  final String _key = 'isDarkMode';

  // Save Theme Fun
  saveThemeToBox(bool isDarkMode) {
    _box.write(_key, isDarkMode);
  }

  // get Theme Fun
  bool loadThemeFromBox() {
    return _box.read<bool>(_key) ?? false;
  }

  // getter theme
  ThemeMode get theme {
    return loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  }

  // switchTheme Fun
  void switchTheme() {
    Get.changeThemeMode(loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    saveThemeToBox(!loadThemeFromBox());
  }
}
