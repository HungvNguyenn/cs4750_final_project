import 'package:flutter/material.dart';
import 'package:puzzle_game/match3/match3_page.dart';
import 'package:puzzle_game/sudoku/sudoku_game_page.dart';
import 'package:puzzle_game/word_search/word_search_page.dart';
import 'package:puzzle_game/grid_puzzle/grid_puzzle_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
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
              'Puzzle Box',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.deepPurple,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Choose a game to play',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Optional big header inside body (can remove if you like)
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Games',
                  style: Theme.of(context).textTheme.headlineMedium ??
                      const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                ),
              ),
              const SizedBox(height: 12),

              _GameCard(
                icon: Icons.grid_on,
                title: 'Sudoku',
                subtitle: 'Classic 9x9 logic puzzle',
                onTap: () => _open(context, const SudokuGamePage()),
              ),
              _GameCard(
                icon: Icons.text_snippet,
                title: 'Word Search',
                subtitle: 'Find all the hidden words',
                onTap: () => _open(context, const WordSearchPage()),
              ),
              _GameCard(
                icon: Icons.grid_4x4,
                title: 'Grid Puzzle',
                subtitle: 'Make every tile become 0',
                onTap: () => _open(context, const GridPuzzlePage()),
              ),
              _GameCard(
                icon: Icons.casino,
                title: 'Match 3',
                subtitle: 'Match gems and rack up points',
                onTap: () => _open(context, const Match3Page()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _GameCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.deepPurple.shade50,
                child: Icon(icon, color: Colors.deepPurple, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
