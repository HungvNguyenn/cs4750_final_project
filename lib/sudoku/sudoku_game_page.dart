// lib/sudoku/sudoku_game_page.dart
import 'package:flutter/material.dart';
import 'package:puzzle_game/pages/congratulation_page.dart';
import 'package:puzzle_game/sudoku/sudoku_number_pad.dart';
import 'package:puzzle_game/sudoku/sudoku_board.dart';
import 'package:puzzle_game/sudoku/sudoku_controller.dart';
import 'package:puzzle_game/rules_dialog.dart';
import '../services/sfx.dart';

class SudokuGamePage extends StatefulWidget {
  const SudokuGamePage({super.key});

  @override
  State<SudokuGamePage> createState() => _SudokuGamePageState();
}

class _SudokuGamePageState extends State<SudokuGamePage> {
  late final SudokuController controller;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    controller = SudokuController();

    // Create a listener that calls setState when controller changes.
    _listener = () {
      if (mounted) setState(() {});
    };

    // Attach the listener.
    controller.addListener(_listener);
  }

  @override
  void dispose() {
    // Remove listener and dispose controller.
    controller.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }

  /// Called when a number button is pressed on the number pad.
  void _onNumberPressed(int num) {
    // Enter the number into the selected cell.
    controller.enterNumber(num);

    // Determine whether the newly entered number is a mistake,
    // using the controller's mistakeAt() on the currently selected cell.
    bool isWrong = false;
    final r = controller.selectedRow;
    final c = controller.selectedCol;

    if (r != null && c != null) {
      isWrong = controller.mistakeAt(r, c);
    }

    if (isWrong) {
      // invalid move
      Sfx.wrong();
    } else {
      // valid move
      Sfx.click();
    }

    // If the puzzle is complete (no zeros and no mistakes anywhere),
    // play success sound and navigate to the congratulations page.
    if (controller.isComplete()) {
      Sfx.correct();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CongratulationPage(),
          ),
        );
      });
    }
  }

  void _clearBoard() {
    // reset sound when clearing the board
    Sfx.reset();
    setState(() {
      controller.clearBoard();
    });
  }

  void _newGame() {
    // reset sound when starting a new game
    Sfx.reset();
    setState(() {
      controller.newGame();
    });
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
              "Sudoku",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.deepPurple,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Fill every row, column & box",
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
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              // Dialog button
              onPressed: () {
                RuleDialog.show(
                  context,
                  title: "How to Play",
                  rules:
                  "• Fill the sudoku grid so that every row, column, and 3x3 grid contains the numbers 1–9.\n"
                      "• To fill a cell, tap the cell and then a number on the number pad.\n"
                      "• The cell will turn red if there is already a number in the row, column, or 3x3 grid.\n"
                      "• Use Clear Board to clear the whole board.\n"
                      "• Use New Game to generate a new game.\n"
                      "• Use Clear Next on the number pad to clear the current cell.\n",
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
      body: Column(
        children: [
          const SizedBox(height: 100),

          // Row of buttons
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Clear board button
                ElevatedButton(
                  onPressed: _clearBoard,
                  child: const Text("Clear Board"),
                ),
                const SizedBox(width: 16),

                // New game button
                ElevatedButton(
                  onPressed: _newGame,
                  child: const Text("New Game"),
                ),
              ],
            ),
          ),

          // Sudoku board
          SudokuBoard(controller: controller),
          const SizedBox(height: 20),

          // Number pad
          SudokuNumberPad(
            controller: controller,
            onNumberPressed: _onNumberPressed,
          ),
        ],
      ),
    );
  }
}
