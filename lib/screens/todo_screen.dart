import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_hive/models/todo_model.dart';
import 'package:todo_app_hive/screens/create_todo_screen.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:todo_app_hive/widgets/todo_card.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  void createTodo({TodoModel? todoModel}) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CreateTodoScreen(
          todoModel: todoModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildAddButton(),
    );
  }

  dynamic _buildAppBar() {
    return AppBar(
      title: Text(
        'Todo\'s',
        style: Theme.of(context).textTheme.headline5,
      ),
      actions: [
        _buildDarkModeButton(),
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildDarkModeButton() {
    return ValueListenableBuilder<Box<bool>>(
      valueListenable: Hive.box<bool>('darkModeBox').listenable(),
      builder: (context, darkModeBox, _) {
        final isDarkMode = darkModeBox.get('isDarkMode');

        return IconButton(
          tooltip: 'Dark Mode',
          icon: Icon(
            isDarkMode == true ? FeatherIcons.moon : FeatherIcons.sun,
            color: isDarkMode == true ? Colors.white : Colors.black,
          ),
          onPressed: () async {
            if (isDarkMode == true) {
              await darkModeBox.put('isDarkMode', false);
              debugPrint('isDarkMode: $isDarkMode');
              debugPrint('Now in darkMode');
            } else {
              await darkModeBox.put('isDarkMode', true);
              debugPrint('isDarkMode: $isDarkMode');
              debugPrint('Now in lightMode');
            }
          },
        );
      },
    );
  }

  Widget _buildDeleteButton() {
    return ValueListenableBuilder<Box<bool>>(
      valueListenable: Hive.box<bool>('darkModeBox').listenable(),
      builder: (context, darkModeBox, _) {
        final isDarkMode = darkModeBox.get('isDarkMode');
        return IconButton(
          tooltip: 'Delete',
          icon: Icon(
            FeatherIcons.trash,
            color: isDarkMode == true ? Colors.white : Colors.black,
          ),
          onPressed: () async {
            await Hive.box<TodoModel>('todoBox').clear();
          },
        );
      },
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      heroTag: 'addTodo',
      onPressed: () => createTodo(),
      tooltip: 'Add',
      child: const Icon(
        FeatherIcons.plus,
        color: Colors.white,
      ),
    );
  }

  Widget _buildEmptyPlaceHolder() {
    return ValueListenableBuilder<Box<bool>>(
        valueListenable: Hive.box<bool>('darkModeBox').listenable(),
        builder: (context, darkModeBox, _) {
          final isDarkMode = darkModeBox.get('isDarkMode');
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    isDarkMode == true
                        ? 'assets/todo_dark_mode.png'
                        : 'assets/todo.png',
                    width: 300,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No todo\'s',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBody() {
    return SafeArea(
      child: ValueListenableBuilder<Box<TodoModel>>(
        valueListenable: Hive.box<TodoModel>('todoBox').listenable(),
        builder: (context, todoModel, _) {
          final todos = todoModel.values.toList().cast<TodoModel>();

          if (todos.isEmpty) {
            return _buildEmptyPlaceHolder();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            shrinkWrap: true,
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return TodoCard(
                todoModel: todos[index],
              );
            },
          );
        },
      ),
    );
  }
}
