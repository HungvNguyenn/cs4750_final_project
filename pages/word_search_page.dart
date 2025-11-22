import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puzzle_game/pages/congratulation_page.dart';
import 'dart:math';
import 'package:puzzle_game/word_search/word_search_generator.dart';
import 'package:puzzle_game/word_search/word_search_controller.dart';

//Main word search page
class WordSearchPage extends StatefulWidget {
  const WordSearchPage({super.key});

  @override
  State<WordSearchPage> createState() => _WordSearchPageState();
}

class _WordSearchPageState extends State<WordSearchPage> {
  List<List<String>> grid = [];
  List<String> words = [];
  WordSearchController? controller;

  final int gridSize = 15; //the grid size of our word search
  double cellSize = 20;   //the size of each cell in the grid

  @override
  void initState() {
    super.initState();
    _loadWords(); //load word from assets when the page is initialized
  }

  //load word from asset file
  Future<void> _loadWords() async {
    String file = await rootBundle.loadString("assets/words.txt");
    List<String> list = file.split('\n').map((e) => e.trim()).toList();
    words = list.where((w) => w.isNotEmpty).toList();
    _newGame();
  }

  //Generate a new Game
  void _newGame() {
    var generator = WordSearchGenerator();
    var selectedWords = (words..shuffle()).take(10).toList();
    var result = generator.generate(selectedWords, gridSize);

    setState(() {
      grid = result.grid;
      words = result.placedWords;
      controller = WordSearchController(grid, words);
    });
  }

  // Handle start of a drag state
  void _startDrag(Offset localPosition) {
    _updateDrag(localPosition);
  }

  //handle how the dragging is over the grid
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

  //handle what happens at the end of the drag
  void _endDrag() {
    setState(() {
      // Check if the selection matches any word
      controller!.checkSelection(controller!.currentSelection);
      controller!.currentSelection.clear();

      if (controller!.isCompleted()) {
        _showWin();
      }
    });
  }

  //navigate to the win page if the win condition is set (when all words are found)
  void _showWin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CongratulationPage(
          message: "Congratulation you found all the words!",
          onNext: () {
            Navigator.pop(context); // close the congratulation page
            _newGame(); // start a new game
          },
        ),
      ),
    );
  }



  //Determine the color of cell, depending if a word is found, or if it currently being selecetd
  Color _getCellColor(Point<int> point) {
    if (controller!.foundCells.contains(point)) {
      return Colors.green.shade300; // Found word stays green
    } else if (controller!.currentSelection.contains(point)) {
      return Colors.yellow.shade300; // Currently dragging
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridWidth = screenWidth * 0.4;
    cellSize = gridWidth / gridSize;
    double gridHeight = cellSize * gridSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Word Search"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue, size: 28,),
          onPressed: () {
              Navigator.pop(context);
          },
        ),
      ),
      body: grid.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // New Game button
            ElevatedButton(
              onPressed: _newGame,
              child: const Text("New Game"),
            ),
            const SizedBox(height: 10),

            // Grid with drag selection
            Center(
              child: GestureDetector(
                onPanStart: (details) => _startDrag(details.localPosition),
                onPanUpdate: (details) => _updateDrag(details.localPosition),
                onPanEnd: (details) => _endDrag(),
                child: SizedBox(
                  width: gridWidth,
                  height: gridHeight,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          border: Border.all(color: Colors.grey.shade700),
                          color: _getCellColor(point),
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: cellSize * 0.5,
                              fontWeight: FontWeight.bold,
                              color: controller!.foundCells.contains(point)
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

            // Word list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: words.map((w) {
                  bool found = controller!.foundWords.contains(w);
                  return Chip(
                    label: Text(
                      w,
                      style: TextStyle(
                        color: found ? Colors.green : Colors.black,
                        fontWeight: found
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    backgroundColor:
                    found ? Colors.green.shade100 : Colors.grey.shade200,
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
