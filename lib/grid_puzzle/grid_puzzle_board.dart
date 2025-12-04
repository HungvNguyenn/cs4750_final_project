// lib/grid_puzzle/grid_puzzle_board.dart
import 'package:flutter/material.dart';
import 'grid_puzzle_controller.dart';

class GridPuzzleBoard extends StatelessWidget {
  final GridPuzzleController controller;
  final void Function(int row, int col) onCellTap;

  const GridPuzzleBoard({
    super.key,
    required this.controller,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final grid = controller.grid;
    final rows = grid.length;
    final cols = grid.isEmpty ? 0 : grid[0].length;

    const double cellSize = 80.0;
    const double spacing = 6.0;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rows, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(cols, (col) {
              final value = grid[row][col];

              if (value == null) {
                // Invisible spacer to keep board shape
                return SizedBox(
                  width: cellSize + spacing,
                  height: cellSize + spacing,
                );
              }

              return Padding(
                padding: const EdgeInsets.all(spacing / 2),
                child: GestureDetector(
                  // tap handling happens in grid_puzzle_page.dart
                  onTap: () => onCellTap(row, col),
                  child: Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 73, 59, 133),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$value',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
