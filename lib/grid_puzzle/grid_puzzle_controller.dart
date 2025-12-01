// lib/grid_puzzle/grid_puzzle_controller.dart
import 'package:flutter/foundation.dart';
import 'grid_puzzle_levels.dart';

class GridPuzzleController extends ChangeNotifier {
  late List<List<int?>> _grid;
  int _currentLevelIndex;

  GridPuzzleController({int initialLevelIndex = 0})
      : _currentLevelIndex = initialLevelIndex {
    _loadLevel(_currentLevelIndex);
  }

  List<List<int?>> get grid => _grid;
  int get currentLevel => _currentLevelIndex + 1;
  int get totalLevels => GridPuzzleLevels.totalLevels;

  bool get hasNextLevel => _currentLevelIndex < totalLevels - 1;

  void _loadLevel(int index) {
    _grid = GridPuzzleLevels.level(index);
    notifyListeners();
  }

  void resetLevel() {
    _loadLevel(_currentLevelIndex);
  }

  void goToNextLevel() {
    if (!hasNextLevel) return;
    _currentLevelIndex++;
    _loadLevel(_currentLevelIndex);
  }

  /// Handle a tap on (row, col).
  /// Rules:
  /// 1. Let v = value at (row, col). If v == null or 0, do nothing.
  /// 2. Add v to all neighbors (including diagonals) that are non-null.
  /// 3. Set (row, col) to 0.
  void tapCell(int row, int col) {
    if (row < 0 ||
        row >= _grid.length ||
        col < 0 ||
        col >= _grid[row].length) return;

    final value = _grid[row][col];
    if (value == null || value == 0) return;

    final int rows = _grid.length;

    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue; // skip self

        final r = row + dr;
        final c = col + dc;

        if (r < 0 || r >= rows) continue;
        if (c < 0 || c >= _grid[r].length) continue;

        final neighbor = _grid[r][c];
        if (neighbor != null) {
          _grid[r][c] = neighbor + value;
        }
      }
    }

    _grid[row][col] = 0;
    notifyListeners();
  }

  /// All non-null cells must be 0.
  bool get isSolved {
    for (final row in _grid) {
      for (final cell in row) {
        if (cell != null && cell != 0) return false;
      }
    }
    return true;
  }
}
