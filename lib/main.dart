import 'package:flutter/material.dart';
import 'package:todo_app_hive/models/todo_model.dart';
import 'package:todo_app_hive/screens/todo_screen.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_hive/utilities/constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>('todoBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: _theme,
      home: const TodoScreen(),
    );
  }
}

ThemeData? _theme = ThemeData(
  primarySwatch: Colors.blue,
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kLightBlue,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(kLightBlue),
    ),
  ),
);
