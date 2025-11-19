import 'package:flutter/material.dart';
import 'sudoku_controller.dart';

class SudokuNumberPad extends StatelessWidget {
  final SudokuController controller;
  final void Function(int)? onNumberPressed;

  const SudokuNumberPad({
    super.key,
    required this.controller,
    this.onNumberPressed,
});


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(9, (i) {
        int number = i + 1;

        return Padding(
          padding: const EdgeInsets.all(6),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(40, 40),
            ),
              onPressed: () {
                if (onNumberPressed != null) {
                  onNumberPressed!(number);
                } else {
                  controller.enterNumber(number); // fallback
                }
              },
            child: Text(
              number.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        );
      }),
    );
  }
}
