import 'dart:math';

// main class that control the game logic for the word search problem
class WordSearchController {
  final List<List<String>> grid;    //the word search board
  final List<String> words;         //list of words the player have to find

  List<String> foundWords = [];     //words the player found
  List<Point<int>> currentSelection = [];   //current cell that being selected/dragged
  Set<Point<int>> foundCells = {}; // Added to track all letters of found words

  WordSearchController(this.grid, this.words);

  // Called when a user taps a cell
  void selectLetter(int row, int col) {
    Point<int> tapped = Point(row, col);

    if (currentSelection.isEmpty) {
      currentSelection.add(tapped);
    } else {
      Point<int> last = currentSelection.last;
      int dx = tapped.x - last.x;
      int dy = tapped.y - last.y;

      // Allow horizontal, vertical, diagonal
      if ((dx == 0 && dy != 0) ||
          (dy == 0 && dx != 0) ||
          (dx.abs() == dy.abs() && dx != 0)) {
        currentSelection.add(tapped);
      } else {
        currentSelection = [tapped];
      }
    }

    _checkCurrentSelection();
  }

  //check the current selection of a word
  void _checkCurrentSelection() {
    String selectedWord =
    currentSelection.map((p) => grid[p.x][p.y]).join().toUpperCase();

    for (String word in words) {
      if (selectedWord == word && !foundWords.contains(word)) {
        foundWords.add(word);
        foundCells.addAll(currentSelection); // mark letters as found
        currentSelection.clear();
        return;
      }
    }

    // Check reverse word
    String reverseWord = selectedWord.split('').reversed.join();
    for (String word in words) {
      if (reverseWord == word && !foundWords.contains(word)) {
        foundWords.add(word);
        foundCells.addAll(currentSelection); // mark letters as found
        currentSelection.clear();
        return;
      }
    }
  }

  bool isCompleted() => foundWords.length == words.length;

  void reset() {
    foundWords.clear();
    currentSelection.clear();
    foundCells.clear();
  }

  void checkSelection(List<Point<int>> selection) {
    if (selection.isEmpty) return;

    // Build the word string from selection
    String word = selection.map((p) => grid[p.x][p.y]).join();

    for (String w in words) {
      if (foundWords.contains(w)) continue;

      if (w == word || w == word.split('').reversed.join()) {
        foundWords.add(w);
        foundCells.addAll(selection); // mark letters as found
        break;
      }
    }

    currentSelection.clear();
  }
}
