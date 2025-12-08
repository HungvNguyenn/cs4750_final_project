import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:puzzle_game/word_search/word_search_generator.dart';
import 'package:puzzle_game/word_search/word_search_controller.dart';
import 'package:puzzle_game/pages/congratulation_page.dart';
import 'package:puzzle_game/rules_dialog.dart';
import '../services/sfx.dart';

// Main word search page
class WordSearchPage extends StatefulWidget {
  const WordSearchPage({super.key});

  @override
  State<WordSearchPage> createState() => _WordSearchPageState();
}

class _WordSearchPageState extends State<WordSearchPage> {
  List<List<String>> grid = [];
  List<String> words = [];
  WordSearchController? controller;

  int gridSize = 15; // grid size
  double cellSize = 20; // pixel size of each cell

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  // Load words from asset file
  Future<void> _loadWords() async {
    String file = await rootBundle.loadString("assets/words.txt");
    List<String> list = file.split('\n').map((e) => e.trim()).toList();
    words = list.where((w) => w.isNotEmpty).toList();
    _newGame();
  }

  // Generate a new game
  void _newGame() {
    var generator = WordSearchGenerator();
    var shuffleWords = List<String>.from(words)..shuffle();
    var selectedWords = shuffleWords.take(10).toList();
    var result = generator.generate(selectedWords, gridSize);

    setState(() {
      grid = result.grid;
      controller = WordSearchController(grid, result.placedWords);
    });
  }

  // Start drag
  void _startDrag(Offset localPosition) {
    _updateDrag(localPosition);
  }

  // Drag over grid
  void _updateDrag(Offset localPosition) {
    int row = (localPosition.dy ~/ cellSize).clamp(0, gridSize - 1);
    int col = (localPosition.dx ~/ cellSize).clamp(0, gridSize - 1);

    Point<int> point = Point(row, col);

    if (!controller!.currentSelection.contains(point)) {
      setState(() {
        controller!.currentSelection.add(point);
      });
    }
  }

  // End drag → check for word match
  void _endDrag() {
    setState(() {
      final before = controller!.foundWords.length;

      controller!.checkSelection(controller!.currentSelection);
      controller!.currentSelection.clear();

      final after = controller!.foundWords.length;

      // If a new word was found → click sound
      if (after > before) {
        Sfx.click();
      }

      // If all words found → success sound + win screen
      if (controller!.isCompleted()) {
        Sfx.correct();
        _showWin();
      }
    });
  }

  // Win dialog
  void _showWin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CongratulationPage(
          message: "Congratulations! You found all the words!",
          onNext: () {
            Navigator.pop(context);
            _newGame();
          },
        ),
      ),
    );
  }

  // Cell color logic
  Color _getCellColor(Point<int> point) {
    if (controller!.foundCells.contains(point)) {
      return Colors.green.shade300;
    } else if (controller!.currentSelection.contains(point)) {
      return Colors.yellow.shade300;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridWidth = screenWidth * 0.35;
    cellSize = gridWidth / gridSize;
    double gridHeight = cellSize * gridSize;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Word Search",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.deepPurple,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Find all hidden words",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: Colors.deepPurple, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                RuleDialog.show(
                  context,
                  title: "How to Play",
                  rules:
                  "• Find the hidden words in the grid.\n"
                      "• Drag across letters to select a word.\n"
                      "• Correct words turn green.\n"
                      "• Find all words to win the game.\n",
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

      body: grid.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // New game + grid size row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Sfx.reset();
                    _newGame();
                  },
                  child: const Text("New Game"),
                ),
                const SizedBox(width: 50),

                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    border:
                    Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton(
                    value: gridSize,
                    icon: const SizedBox.shrink(),
                    underline: const SizedBox(),
                    style: const TextStyle(
                        color: Colors.black, fontSize: 14),
                    items: const [
                      DropdownMenuItem(value: 5, child: Text("5x5")),
                      DropdownMenuItem(value: 10, child: Text("10x10")),
                      DropdownMenuItem(value: 15, child: Text("15x15")),
                      DropdownMenuItem(value: 20, child: Text("20x20")),
                    ],
                    onChanged: (newSize) {
                      setState(() {
                        gridSize = newSize!;
                        _newGame();
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Word Search Grid
            Center(
              child: GestureDetector(
                onPanStart: (details) =>
                    _startDrag(details.localPosition),
                onPanUpdate: (details) =>
                    _updateDrag(details.localPosition),
                onPanEnd: (details) => _endDrag(),
                child: SizedBox(
                  width: gridWidth,
                  height: gridHeight,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                    ),
                    itemCount: gridSize * gridSize,
                    itemBuilder: (context, index) {
                      int row = index ~/ gridSize;
                      int col = index % gridSize;
                      String letter = grid[row][col];
                      Point<int> point = Point(row, col);

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade700),
                          color: _getCellColor(point),
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: cellSize * 0.5,
                              fontWeight: FontWeight.bold,
                              color: controller!.foundCells
                                  .contains(point)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Word list summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: controller!.words.map((w) {
                  bool found = controller!.foundWords.contains(w);
                  return Chip(
                    label: Text(
                      w,
                      style: TextStyle(
                        color:
                        found ? Colors.green : Colors.black,
                        fontWeight: found
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    backgroundColor: found
                        ? Colors.green.shade100
                        : Colors.grey.shade200,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
