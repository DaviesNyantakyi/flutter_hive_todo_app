import 'package:flutter/material.dart';
import 'package:todo_app_hive/utilities/constant.dart';

class CustomColorPicker extends StatefulWidget {
  final Color pickerColor;
  final Function(Color) onColorChanged;
  final List<Color> colors;
  const CustomColorPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    this.colors = const [
      kPink,
      kLightBlue,
      kDarkBlue,
      kSeaGreen,
    ],
  }) : super(key: key);

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) => FloatingActionButton(
          backgroundColor: widget.colors[index],
          child: Container(),
          onPressed: () {
            widget.onColorChanged(widget.colors[index]);
          },
        ),
        separatorBuilder: (conext, index) => const SizedBox(width: 16),
        itemCount: widget.colors.length,
      ),
    );
  }
}
