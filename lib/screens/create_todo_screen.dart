import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_hive/models/todo_model.dart';
import 'package:todo_app_hive/models/widgets/custom_snackbar.dart';
import 'package:uuid/uuid.dart';
import 'package:fast_color_picker/fast_color_picker.dart';

class CreateTodoScreen extends StatefulWidget {
  final TodoModel? todoModel;
  const CreateTodoScreen({Key? key, this.todoModel}) : super(key: key);

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  TextEditingController todoCntlr = TextEditingController();
  final GlobalKey<FormState> todoKey = GlobalKey<FormState>();
  Color selectedColor = Colors.indigo;
  var uuid = const Uuid();

  DateTime? selectedDate;

  @override
  void initState() {
    if (widget.todoModel != null && widget.todoModel?.color != null) {
      selectedColor = Color(widget.todoModel!.color);
      todoCntlr = TextEditingController(text: widget.todoModel!.title);
      selectedDate = widget.todoModel?.createdAt;
    }

    setState(() {});
    super.initState();
  }

  Future<void> createTodo() async {
    FocusScope.of(context).unfocus();
    final validTodoField = todoKey.currentState?.validate();

    if (selectedDate == null) {
      showCustomSnackBar(context: context, message: 'Date required');
    }

    if (validTodoField == true &&
        todoCntlr.text.isNotEmpty &&
        selectedDate != null) {
      final id = uuid.v1();

      final todo = TodoModel(
        id: id,
        title: todoCntlr.text,
        createdAt: selectedDate!,
        color: selectedColor.value,
      );

      final todoBox = Hive.box<TodoModel>('todoBox');
      await todoBox.put(id, todo);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> updateTodo() async {
    FocusScope.of(context).unfocus();
    final validTodoField = todoKey.currentState?.validate();

    if (selectedDate == null) {
      showCustomSnackBar(context: context, message: 'Date required');
    }

    if (validTodoField == true &&
        todoCntlr.text.isNotEmpty &&
        selectedDate != null) {
      widget.todoModel?.title = todoCntlr.text;
      widget.todoModel?.color = selectedColor.value;
      widget.todoModel?.updatedAt = DateTime.now();
      widget.todoModel?.createdAt = selectedDate!;
      await widget.todoModel?.save();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 16),
              _buildColorPicker(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildCreateButton(),
    );
  }

  Widget _buildTitleField() {
    return Form(
      key: todoKey,
      child: TextFormField(
        textInputAction: TextInputAction.newline,
        maxLength: null,
        maxLines: null,
        controller: todoCntlr,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field required';
          }
          return null;
        },
        onChanged: (value) {
          todoKey.currentState?.validate();
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final tempDate = await showDatePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.calendar,
            initialDate: widget.todoModel?.createdAt ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2070, 01, 01),
          );

          selectedDate = tempDate;
          setState(() {});
        },
        icon: const Icon(Icons.calendar_month),
        label: const Text('date'),
      ),
    );
  }

  Widget _buildColorPicker() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FastColorPicker(
        selectedColor: selectedColor,
        onColorSelected: (color) {
          setState(() {
            selectedColor = color;
          });
        },
      ),
    );
  }

  Widget _buildCreateButton() {
    return FloatingActionButton.extended(
      backgroundColor: Colors.blue,
      onPressed: widget.todoModel != null ? updateTodo : createTodo,
      label: const Text('Create'),
    );
  }
}
