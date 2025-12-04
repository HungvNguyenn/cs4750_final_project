import 'package:flutter/material.dart';

class RuleDialog {
  static void show(
      BuildContext context, {
        required String title,
        required String rules,
  }) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: SizedBox(
            child: Text(
                rules,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
    );
  }
}