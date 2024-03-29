import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_hive/models/todo_model.dart';
import 'package:todo_app_hive/utilities/constant.dart';
import 'package:todo_app_hive/utilities/formal_dates.dart';
import 'package:todo_app_hive/utilities/hive_boxes.dart';
import 'package:todo_app_hive/widgets/custom_color_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:feather_icons/feather_icons.dart';

class CreateTodoScreen extends StatefulWidget {
  final TodoModel? todoModel;
  const CreateTodoScreen({Key? key, this.todoModel}) : super(key: key);

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  TextEditingController todoCntlr = TextEditingController();
  final GlobalKey<FormState> todoKey = GlobalKey<FormState>();
  Color selectedColor = kDarkBlue;
  var uuid = const Uuid();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    if (widget.todoModel != null && widget.todoModel?.color != null) {
      selectedColor = Color(widget.todoModel!.color!);
      todoCntlr = TextEditingController(text: widget.todoModel!.title);
      selectedDate = widget.todoModel?.createdAt ?? DateTime.now();
    }

    setState(() {});
    super.initState();
  }

  Future<void> createTodo() async {
    FocusScope.of(context).unfocus();
    final validTodoField = todoKey.currentState?.validate();

    if (validTodoField == true && todoCntlr.text.isNotEmpty) {
      // Generate id base on the time.
      final id = uuid.v1();

      final todo = TodoModel(
        id: id,
        title: todoCntlr.text,
        createdAt: selectedDate,
        color: selectedColor.value,
      );

      // Place the todo In the TodoBox.
      final todoBox = HiveBoxes().getTodoBox();
      await todoBox.put(id, todo);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> updateTodo() async {
    FocusScope.of(context).unfocus();
    final validTodoField = todoKey.currentState?.validate();

    if (validTodoField == true && todoCntlr.text.isNotEmpty) {
      widget.todoModel?.title = todoCntlr.text;
      widget.todoModel?.color = selectedColor.value;
      widget.todoModel?.updatedAt = DateTime.now();
      widget.todoModel?.createdAt = selectedDate;
      await widget.todoModel?.save();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleField(),
                const SizedBox(height: 32),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildDatePicker(),
                    const SizedBox(width: 16),
                    _buildColorPicker(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildCreateButton(),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 78),
      child: ValueListenableBuilder<Box<bool>>(
          valueListenable: Hive.box<bool>('darkModeBox').listenable(),
          builder: (context, darkModeBox, _) {
            final isDarkMode = darkModeBox.get('isDarkMode');
            return AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 70,
              actions: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode == true ? Colors.white : Colors.black,
                    ),
                  ),
                  margin: const EdgeInsets.only(right: 8, top: 8),
                  child: IconButton(
                    tooltip: 'Close',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      FeatherIcons.x,
                      color: isDarkMode == true ? Colors.white : Colors.black,
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget _buildTitleField() {
    return ValueListenableBuilder<Box<bool>>(
        valueListenable: Hive.box<bool>('darkModeBox').listenable(),
        builder: (context, darkModeBox, _) {
          final isDarkMode = darkModeBox.get('isDarkMode');
          return Form(
            key: todoKey,
            child: TextFormField(
              textInputAction: TextInputAction.newline,
              maxLength: null,
              maxLines: null,
              controller: todoCntlr,
              decoration: InputDecoration(
                hintText: 'Enter a new task',
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isDarkMode == true
                          ? Colors.white.withOpacity(0.4)
                          : kDarkBlue.withOpacity(0.4),
                      fontWeight: FontWeight.w500,
                    ),
              ),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: isDarkMode == true ? Colors.white : kDarkBlue,
                    fontWeight: FontWeight.w500,
                  ),
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
        });
  }

  Widget _buildDatePicker() {
    return ElevatedButton.icon(
      onPressed: () async {
        final tempDate = await showDatePicker(
          context: context,
          initialEntryMode: DatePickerEntryMode.calendar,
          initialDate: widget.todoModel?.createdAt ?? selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2070, 01, 01),
        );

        if (tempDate != null) {
          selectedDate = tempDate;
        }
        setState(() {});
      },
      icon: const Icon(FeatherIcons.calendar, color: Colors.white),
      label: Text(
        selectedDate.day == DateTime.now().day
            ? 'Today'
            : FormalDates.dateDMY(date: selectedDate),
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildColorPicker() {
    return SizedBox(
      height: 42,
      child: FloatingActionButton(
        elevation: 0,
        heroTag: 'Color',
        backgroundColor: selectedColor,
        tooltip: 'Color',
        onPressed: () async {
          FocusScope.of(context).unfocus();
          await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return Dialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(kRadius),
                  ),
                ),
                child: CustomColorPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (color) {
                    selectedColor = color;
                    super.setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCreateButton() {
    return FloatingActionButton.extended(
      heroTag: 'Create',
      onPressed: widget.todoModel != null ? updateTodo : createTodo,
      label: Text(
        'Create',
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
