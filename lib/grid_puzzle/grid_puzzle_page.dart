// lib/grid_puzzle/grid_puzzle_page.dart
import 'package:flutter/material.dart';
import 'package:puzzle_game/pages/congratulation_page.dart';
import 'package:puzzle_game/rules_dialog.dart';
import 'grid_puzzle_board.dart';
import 'grid_puzzle_controller.dart';
import '../services/sfx.dart';

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
    // play click sound on every tap
    Sfx.click();

    controller.tapCell(row, col);

    if (!controller.isSolved) return;

    // play correct sound when the puzzle is solved
    Sfx.correct();

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

  void _handleReset() {
    // play reset sound
    Sfx.reset();

    // existing reset logic
    controller.resetLevel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Grid Puzzle',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Make every tile 0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12), // space from right edge
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                RuleDialog.show(
                  context,
                  title: "How to Play",
                  rules:
                  "• When you click on a square, the value in that square is added to all adjacent squares.\n"
                      "• The clicked square becomes 0.\n"
                      "• The goal is to make the whole grid 0.\n"
                      "• Good luck!\n",
                );
              },
              child: const Text(
                "Rules",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
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
                  onPressed: _handleReset,
                  child: const Text('Reset Level'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed:
                  controller.hasNextLevel ? controller.goToNextLevel : null,
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
