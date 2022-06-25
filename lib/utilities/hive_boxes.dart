import 'package:hive/hive.dart';
import 'package:todo_app_hive/models/todo_model.dart';

class HiveBoxes {
  Box<TodoModel> getTodoBox() => Hive.box<TodoModel>('todoBox');
}
