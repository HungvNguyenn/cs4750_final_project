import 'package:flutter/material.dart';
import 'sudoku_controller.dart';

class SudokuBoard extends StatelessWidget {
  final SudokuController controller;
  const SudokuBoard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(border: Border.all(width: 3)),
        child: Column(
          children: List.generate(9, (row) {
            return Expanded(
              child: Row(
                children: List.generate(9, (col) {
                  bool selected = controller.selectedRow == row &&
                      controller.selectedCol == col;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectCell(row, col),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: controller.fixed[row][col]
                              ? Colors.grey.shade300
                              : controller.mistakeAt(row, col)
                                ?Colors.red.shade300
                                :(selected? Colors.yellow.shade300 : Colors.white),
                          border: Border(
                            top: BorderSide(width: row % 3 == 0 ? 2 : 0.5),
                            left: BorderSide(width: col % 3 == 0 ? 2 : 0.5),
                            right: BorderSide(width: col == 8 ? 2 : 0.5),
                            bottom: BorderSide(width: row == 8 ? 2 : 0.5),
                          ),
                        ),
                        child: Text(
                          controller.board[row][col] == 0
                              ? ""
                              : controller.board[row][col].toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}
