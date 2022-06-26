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
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      tooltip: 'Delete',
      icon: const Icon(
        FeatherIcons.trash,
        color: Colors.black,
      ),
      onPressed: () async {
        await Hive.box<TodoModel>('todoBox').clear();
      },
    );
  }

  FloatingActionButton _buildAddButton() {
    return FloatingActionButton(
      heroTag: 'addTodo',
      onPressed: () => createTodo(),
      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }

  Widget _buildEmptyPlaceHolder() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/todo.png',
              width: 300,
            ),
            Text(
              'No todo\'s',
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
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
