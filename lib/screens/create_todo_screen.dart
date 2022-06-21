import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_hive/models/todo_model.dart';
import 'package:uuid/uuid.dart';

import 'package:fast_color_picker/fast_color_picker.dart';

class CreateTodoScreen extends StatefulWidget {
  const CreateTodoScreen({Key? key}) : super(key: key);

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  final initDate = DateTime.now();
  final TextEditingController todoCntlr = TextEditingController();
  final GlobalKey<FormState> todoKey = GlobalKey<FormState>();
  Color selectedColor = Colors.indigo;
  var uuid = const Uuid();

  DateTime? selectedDate;

  Future<void> createTodo() async {
    FocusScope.of(context).unfocus();
    final validTodoField = todoKey.currentState?.validate();

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Date required',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
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
            initialDate: initDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2070, 01, 01),
          );
          if (tempDate != null) {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(tempDate),
            );
            if (time != null) {
              selectedDate = DateTime(
                tempDate.year,
                tempDate.month,
                tempDate.day,
                time.hour,
                time.minute,
              );
            }
          }
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
      onPressed: createTodo,
      label: const Text('Create'),
    );
  }
}
