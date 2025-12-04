// lib/match3/match3_page.dart
import 'package:flutter/material.dart';
import 'match3_controller.dart';
import 'match3_board.dart';

class Match3Page extends StatefulWidget {
  const Match3Page({super.key});

  @override
  State<Match3Page> createState() => _Match3PageState();
}

class _Match3PageState extends State<Match3Page> {
  late Match3Controller controller;

  @override
  void initState() {
    super.initState();
    controller = Match3Controller();
    controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    super.dispose();
  }

  void _handleGemTap(int row, int col) {
    controller.selectGem(row, col);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match 3'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Score display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.deepPurple.shade300,
                    width: 2,
                  ),
                ),
                child: Text(
                  'Score: ${controller.score}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Instructions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Match 3 or more gems of the same color',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Game board
              Match3Board(
                controller: controller,
                onGemTap: _handleGemTap,
              ),

              const SizedBox(height: 24),

              // Reset button
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    controller.resetGame();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('New Game'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.deepPurple.shade200,
                  foregroundColor: Colors.deepPurple.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}