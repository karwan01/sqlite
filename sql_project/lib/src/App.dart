import 'package:flutter/material.dart';
import 'package:sql_project/src/update_screen/update_screen.dart';

import 'add_screen/add_screen.dart';
import 'main_screen/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/addScreen': (context) => AddScreen(),
        '/update': (context) => UpdateScreen(),
      },
    );
  }
}
