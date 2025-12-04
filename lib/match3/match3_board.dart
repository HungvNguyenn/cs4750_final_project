// lib/match3/match3_board.dart
import 'package:flutter/material.dart';
import 'match3_controller.dart';

class Match3Board extends StatelessWidget {
  final Match3Controller controller;
  final void Function(int row, int col) onGemTap;

  const Match3Board({
    super.key,
    required this.controller,
    required this.onGemTap,
  });

  Color _getGemColor(GemType type) {
    switch (type) {
      case GemType.red:
        return Colors.red;
      case GemType.blue:
        return Colors.blue;
      case GemType.green:
        return Colors.green;
      case GemType.yellow:
        return Colors.yellow;
      case GemType.purple:
        return Colors.purple;
      case GemType.orange:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double cellSize = 45.0;
    const double spacing = 2.0;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(Match3Controller.rows, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(Match3Controller.cols, (col) {
              final gem = controller.grid[row][col];
              final isSelected = controller.selectedRow == row &&
                  controller.selectedCol == col;

              if (gem == null) {
                return SizedBox(
                  width: cellSize + spacing,
                  height: cellSize + spacing,
                );
              }

              return Padding(
                padding: const EdgeInsets.all(spacing / 2),
                child: GestureDetector(
                  onTap: () => onGemTap(row, col),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: _getGemColor(gem.type),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.black26,
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: gem.isMatched
                        ? const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 20,
                    )
                        : null,
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}