import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_hive/models/todo_model.dart';
import 'package:todo_app_hive/screens/create_todo_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> createTodo({TodoModel? todoModel}) async {
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
      appBar: AppBar(
        title: const Text('Todo\'s'),
        actions: [
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await Hive.box<TodoModel>('todoBox').clear();
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ValueListenableBuilder<Box<TodoModel>>(
            valueListenable: Hive.box<TodoModel>('todoBox').listenable(),
            builder: (context, todoModel, _) {
              final todo = todoModel.values.toList().cast<TodoModel>();

              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                shrinkWrap: true,
                itemCount: todo.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (DismissDirection direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        todo[index].isDone = !todo[index].isDone;
                        todo[index].save();
                        setState(() {});
                      } else {
                        await todo[index].delete();
                      }
                    },
                    background: Container(
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      padding: const EdgeInsets.only(right: 10),
                      alignment: Alignment.centerRight,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        todo[index].title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: todo[index].isDone
                              ? TextDecoration.lineThrough
                              : null,
                          decorationThickness: 2.85,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(8),
                      trailing: IconButton(
                        onPressed: () => createTodo(todoModel: todo[index]),
                        tooltip: 'Edit',
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      tileColor: Color(todo[index].color),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createTodo,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
