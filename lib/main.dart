import 'package:flutter/material.dart';
import 'package:todo_app_hive/models/todo_model.dart';
import 'package:todo_app_hive/screens/todo_screen.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_hive/utilities/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>('todoBox');
  await Hive.openBox<bool>('darkModeBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<bool>>(
      valueListenable: Hive.box<bool>('darkModeBox').listenable(),
      builder: (context, darkModeBox, _) {
        final isDarkMode = darkModeBox.get('isDarkMode');
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme:
              isDarkMode == true ? CustomTheme.darkMode : CustomTheme.lightMode,
          home: const TodoScreen(),
        );
      },
    );
  }
}
