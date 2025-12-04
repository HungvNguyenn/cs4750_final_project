import 'package:flutter/material.dart';
import 'package:puzzle_game/match3/match3_page.dart';
import 'package:puzzle_game/sudoku/sudoku_game_page.dart';
import 'package:puzzle_game/word_search/word_search_page.dart';
import 'package:puzzle_game/grid_puzzle/grid_puzzle_page.dart';


class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gameTitles = [
      'Sudoku',
      'Word Search',
      'Grid Puzzle',
      'Match 3',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Box'),
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
                  if (title == 'Word Search') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WordSearchPage()),
                    );
                    return;
                  }
                  if (title == 'Grid Puzzle') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GridPuzzlePage()),
                    );
                    return;
                  }

                  if (title == 'Match 3') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Match3Page()),
                    );
                    return;
                  }
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
