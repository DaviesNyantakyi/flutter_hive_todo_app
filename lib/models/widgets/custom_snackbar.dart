import 'package:flutter/material.dart';

Future<void> showCustomSnackBar({
  required BuildContext context,
  required String message,
}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red,
    ),
  );
}
