import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoapp/db/db_helper.dart';

import 'Ui/pages/home_page.dart';
import 'Ui/size_config.dart';
import 'Ui/theme.dart';
import 'services/theme_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDatabase();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      // #2
      themeMode: ThemeServices().theme,
      home: const HomePage(),
    );
  }
}
