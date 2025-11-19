import 'package:flutter/material.dart';
import 'package:puzzle_game/pages/congratulation_page.dart';
import 'package:puzzle_game/sudoku/sudoku_number_pad.dart';
import 'package:puzzle_game/sudoku/sudoku_board.dart';
import 'package:puzzle_game/sudoku/sudoku_controller.dart';

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

    // Attach the listener
    controller.addListener(_listener);
  }

  @override
  void dispose() {
    // Remove listener and dispose controller if desired
    controller.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }

  //helper method
  void _onNumberPressed(int num) {
    controller.enterNumber(num);

    if(controller.isComplete()) {
      //navigate to congratulation page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CongratulationPage()
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sudoku")),
      body: Column(
        children: [
          //rows of buttons
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //clear selection button
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          controller.clearBoard();
                        });
                      },
                      child: const Text("Clear Board"),
                  ),
                  const SizedBox(width: 16),

                  //new game button
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          controller.newGame();
                        });
                      },
                      child: const Text("New Game"),
                  ),
                ],
              ),
          ),

          // Pass the controller to the board and number pad
          SudokuBoard(controller: controller),
          const SizedBox(height: 20),

          //number pad
          SudokuNumberPad(
            controller: controller,
            onNumberPressed: _onNumberPressed,
          ),
        ],
      ),
    );
  }
}
