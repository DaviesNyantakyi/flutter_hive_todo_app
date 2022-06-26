import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_hive/models/todo_model.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:todo_app_hive/screens/create_todo_screen.dart';
import 'package:todo_app_hive/utilities/constant.dart';

class TodoCard extends StatefulWidget {
  final TodoModel todoModel;
  const TodoCard({
    Key? key,
    required this.todoModel,
  }) : super(key: key);

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  bool isChecked = false;
  Future<void> onDismissed(DismissDirection direction) async {
    if (direction == DismissDirection.startToEnd) {
      widget.todoModel.isDone = !widget.todoModel.isDone;
      await widget.todoModel.save();
    } else {
      await widget.todoModel.delete();
    }
  }

  void createTodo({required TodoModel todoModel}) async {
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
    return Dismissible(
      key: UniqueKey(),
      onDismissed: onDismissed,
      background: _buildTileBackgroundColor(
        aligment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 10),
        color: Colors.green.shade700,
        icon: FeatherIcons.check,
      ),
      secondaryBackground: _buildTileBackgroundColor(
        aligment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 10),
        color: Colors.red.shade700,
        icon: FeatherIcons.trash,
      ),
      child: ListTile(
        leading: _buildLeading(),
        title: _buildTitle(),
        contentPadding: const EdgeInsets.all(8),
        trailing: _buildTrailing(),
        tileColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildTileBackgroundColor({
    required Color color,
    required IconData icon,
    EdgeInsets? padding,
    AlignmentGeometry? aligment,
  }) {
    return Container(
      padding: padding,
      alignment: aligment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLeading() {
    return GestureDetector(
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.only(left: 8.0),
        decoration: BoxDecoration(
          color: Color(
            widget.todoModel.isDone
                ? kDarkBlue.value
                : widget.todoModel.color ?? kDarkBlue.value,
          ),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(4.0),
        child: widget.todoModel.isDone
            ? const Icon(
                FeatherIcons.check,
                color: Colors.white,
                size: 14,
              )
            : Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(kRadius),
                  ),
                ),
              ),
      ),
      onTap: () async {
        widget.todoModel.isDone = !widget.todoModel.isDone;
        await widget.todoModel.save();
      },
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.todoModel.title,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 18,
        decoration: widget.todoModel.isDone ? TextDecoration.lineThrough : null,
        decorationThickness: 2.85,
      ),
    );
  }

  Widget _buildTrailing() {
    return IconButton(
      onPressed: () => createTodo(todoModel: widget.todoModel),
      tooltip: 'Edit',
      icon: const Icon(
        FeatherIcons.edit,
        color: Colors.black,
      ),
    );
  }
}
