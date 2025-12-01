// lib/grid_puzzle/grid_puzzle_page.dart
import 'package:flutter/material.dart';
import 'package:puzzle_game/pages/congratulation_page.dart';
import 'grid_puzzle_board.dart';
import 'grid_puzzle_controller.dart';

class GridPuzzlePage extends StatefulWidget {
  const GridPuzzlePage({super.key});

  @override
  State<GridPuzzlePage> createState() => _GridPuzzlePageState();
}

class _GridPuzzlePageState extends State<GridPuzzlePage> {
  late GridPuzzleController controller;

  @override
  void initState() {
    super.initState();
    controller = GridPuzzleController(initialLevelIndex: 0);
    controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    // Just rebuild when the controller notifies.
    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    super.dispose();
  }

  void _handleCellTap(int row, int col) {
  controller.tapCell(row, col);

  if (!controller.isSolved) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (controller.hasNextLevel) {
      // Normal per-level congratulations
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CongratulationPage(
            message: 'You solved Level ${controller.currentLevel}!',
            onNext: () {
              // Close congrats page, then go to the next level
              Navigator.pop(context);
              setState(() {
                controller.goToNextLevel();
              });
            },
          ),
        ),
      );
    } else {
      // Final level beaten – show “all levels done” screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CongratulationPage(
            message: 'You completed all levels!',
            onNext: () {
              // Close congrats page, then go back to the main menu
              Navigator.pop(context); // pop CongratulationPage
              Navigator.pop(context); // pop GridPuzzlePage -> back to MainMenuPage
            },
          ),
        ),
      );
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Puzzle'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Level ${controller.currentLevel}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
              ),
            ),
            const SizedBox(height: 24),
            GridPuzzleBoard(
              controller: controller,
              onCellTap: _handleCellTap,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controller.resetLevel,
                  child: const Text('Reset Level'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: controller.hasNextLevel
                      ? controller.goToNextLevel
                      : null,
                  child: const Text('Next Level'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
