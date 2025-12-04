// lib/match3/match3_controller.dart
import 'package:flutter/foundation.dart';
import 'dart:math';

enum GemType {
  red,
  blue,
  green,
  yellow,
  purple,
  orange,
}

class Gem {
  GemType type;
  bool isMatched;

  Gem(this.type) : isMatched = false;
}

class Match3Controller extends ChangeNotifier {
  static const int rows = 8;
  static const int cols = 8;

  late List<List<Gem?>> grid;
  int score = 0;
  int? selectedRow;
  int? selectedCol;

  bool _isInitializing = false;

  final Random _random = Random();

  Match3Controller() {
    _initializeGrid();
  }

  void _initializeGrid() {
    _isInitializing = true;
    score = 0;

    grid = List.generate(
      rows,
          (row) => List.generate(
        cols,
            (col) => Gem(_randomGemType()),
      ),
    );

    // Remove initial matches
    while (_findAndMarkMatches()) {
      _removeMatchedGems();
      _applyGravity();
      _fillEmptySpaces();
    }

    _isInitializing = false;
    notifyListeners();
  }

  GemType _randomGemType() {
    return GemType.values[_random.nextInt(GemType.values.length)];
  }

  void selectGem(int row, int col) {
    if (selectedRow == null && selectedCol == null) {
      // First selection
      selectedRow = row;
      selectedCol = col;
    } else {
      // Second selection - check if adjacent
      if (_isAdjacent(selectedRow!, selectedCol!, row, col)) {
        _swapGems(selectedRow!, selectedCol!, row, col);

        if (_findAndMarkMatches()) {
          // Valid move
          _processMatches();
          selectedRow = null;
          selectedCol = null;
        } else {
          // Invalid move - swap back
          _swapGems(selectedRow!, selectedCol!, row, col);
          selectedRow = null;
          selectedCol = null;
        }
      } else {
        // Not adjacent - select new gem
        selectedRow = row;
        selectedCol = col;
      }
    }

    notifyListeners();
  }

  bool _isAdjacent(int row1, int col1, int row2, int col2) {
    int rowDiff = (row1 - row2).abs();
    int colDiff = (col1 - col2).abs();

    return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1);
  }

  void _swapGems(int row1, int col1, int row2, int col2) {
    Gem? temp = grid[row1][col1];
    grid[row1][col1] = grid[row2][col2];
    grid[row2][col2] = temp;
  }

  bool _findAndMarkMatches() {
    bool foundMatches = false;

    // Reset all matched flags
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (grid[row][col] != null) {
          grid[row][col]!.isMatched = false;
        }
      }
    }

    // Check horizontal matches
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols - 2; col++) {
        if (grid[row][col] != null &&
            grid[row][col + 1] != null &&
            grid[row][col + 2] != null) {
          GemType type = grid[row][col]!.type;

          if (grid[row][col + 1]!.type == type &&
              grid[row][col + 2]!.type == type) {
            // Mark as matched
            grid[row][col]!.isMatched = true;
            grid[row][col + 1]!.isMatched = true;
            grid[row][col + 2]!.isMatched = true;
            foundMatches = true;

            // Check for longer matches
            int extraCol = col + 3;
            while (extraCol < cols &&
                grid[row][extraCol] != null &&
                grid[row][extraCol]!.type == type) {
              grid[row][extraCol]!.isMatched = true;
              extraCol++;
            }
          }
        }
      }
    }

    // Check vertical matches
    for (int col = 0; col < cols; col++) {
      for (int row = 0; row < rows - 2; row++) {
        if (grid[row][col] != null &&
            grid[row + 1][col] != null &&
            grid[row + 2][col] != null) {
          GemType type = grid[row][col]!.type;

          if (grid[row + 1][col]!.type == type &&
              grid[row + 2][col]!.type == type) {
            // Mark as matched
            grid[row][col]!.isMatched = true;
            grid[row + 1][col]!.isMatched = true;
            grid[row + 2][col]!.isMatched = true;
            foundMatches = true;

            // Check for longer matches
            int extraRow = row + 3;
            while (extraRow < rows &&
                grid[extraRow][col] != null &&
                grid[extraRow][col]!.type == type) {
              grid[extraRow][col]!.isMatched = true;
              extraRow++;
            }
          }
        }
      }
    }

    return foundMatches;
  }

  void _processMatches() {
    _removeMatchedGems();
    _applyGravity();
    _fillEmptySpaces();

    // Check for chain reactions
    if (_findAndMarkMatches()) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _processMatches();
      });
    }
  }

  void _removeMatchedGems() {
    int gemsRemoved = 0;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (grid[row][col] != null && grid[row][col]!.isMatched) {
          grid[row][col] = null;
          gemsRemoved++;
        }
      }
    }

    if (!_isInitializing) {
      score += gemsRemoved * 10;
    }
    notifyListeners();
  }

  void _applyGravity() {
    for (int col = 0; col < cols; col++) {
      // Start from bottom and move up
      int writeRow = rows - 1;

      for (int row = rows - 1; row >= 0; row--) {
        if (grid[row][col] != null) {
          if (row != writeRow) {
            grid[writeRow][col] = grid[row][col];
            grid[row][col] = null;
          }
          writeRow--;
        }
      }
    }
  }

  void _fillEmptySpaces() {
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (grid[row][col] == null) {
          grid[row][col] = Gem(_randomGemType());
        }
      }
    }

    notifyListeners();
  }

  void resetGame() {
    selectedRow = null;
    selectedCol = null;
    _initializeGrid();
  }
}