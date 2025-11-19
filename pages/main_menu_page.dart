import 'package:flutter/material.dart';
import 'package:puzzle_game/pages/sudoku_game_page.dart';


class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gameTitles = [
      'Sudoku',
      'Word Puzzle',
      'Number Puzzle',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Game Collection'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: gameTitles.map((title) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: Colors.deepPurple.shade100,
                  foregroundColor: Colors.deepPurple.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (title == 'Sudoku') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SudokuGamePage()),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title coming soon!')),
                  );
                },
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
