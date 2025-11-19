import 'package:flutter/material.dart';
import 'dart:math';

class SudokuController extends ChangeNotifier {
  List<List<int>> board = List.generate(9, (_) => List.filled(9, 0));
  List<List<bool>> fixed = List.generate(9, (_) => List.filled(9, false));

  int? selectedRow;
  int? selectedCol;

  SudokuController() {
    generatePuzzle();
  }

//TODO: comments
  void selectCell(int row, int col) {
    if (fixed[row][col]) return; // cannot select fixed cells
    selectedRow = row;
    selectedCol = col;
    notifyListeners();
  }

//TODO: comments
  void enterNumber(int number) {
    if (selectedRow == null || selectedCol == null) return;

    int r = selectedRow!;
    int c = selectedCol!;

    if (fixed[r][c]) return;

    board[r][c] = number;
    notifyListeners();
  }

//TODO: comments
  bool mistakeAt(int row, int col) {
    int value = board[row][col];
    if (value == 0) return false;

    // check row
    for (int c = 0; c < 9; c++) {
      if (c != col && board[row][c] == value) return true;
    }

    // check column
    for (int r = 0; r < 9; r++) {
      if (r != row && board[r][col] == value) return true;
    }

    // check 3×3 box
    int boxRow = (row ~/ 3) * 3;
    int boxCol = (col ~/ 3) * 3;

    for (int r = boxRow; r < boxRow + 3; r++) {
      for (int c = boxCol; c < boxCol + 3; c++) {
        if ((r != row || c != col) && board[r][c] == value) return true;
      }
    }

    return false;
  }

//TODO: comments
  void generatePuzzle() {
    board = List.generate(9, (_) => List.filled(9, 0));
    fixed = List.generate(9, (_) => List.filled(9, false));

    _fillDiagonalBoxes();
    _solve(0, 0);
    _removeCells(50); // remove 50 numbers (medium difficulty)

    notifyListeners();
  }

  // Fill 3 × diagonal boxes because they are independent
  void _fillDiagonalBoxes() {
    for (int i = 0; i < 9; i += 3) {
      _fillBox(i, i);
    }
  }

  void _fillBox(int row, int col) {
    Random rnd = Random();
    List<int> nums = List.generate(9, (i) => i + 1)
      ..shuffle();

    int index = 0;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        board[row + r][col + c] = nums[index++];
      }
    }
  }

  // Backtracking solver
  bool _solve(int row, int col) {
    if (row == 9) return true;
    if (col == 9) return _solve(row + 1, 0);
    if (board[row][col] != 0) return _solve(row, col + 1);

    for (int num = 1; num <= 9; num++) {
      if (!_conflicts(row, col, num)) {
        board[row][col] = num;
        if (_solve(row, col + 1)) return true;
        board[row][col] = 0;
      }
    }
    return false;
  }

  bool _conflicts(int row, int col, int num) {
    // row
    for (int c = 0; c < 9; c++)
      if (board[row][c] == num) return true;

    // column
    for (int r = 0; r < 9; r++)
      if (board[r][col] == num) return true;

    // box
    int br = (row ~/ 3) * 3;
    int bc = (col ~/ 3) * 3;
    for (int r = br; r < br + 3; r++) {
      for (int c = bc; c < bc + 3; c++) {
        if (board[r][c] == num) return true;
      }
    }
    return false;
  }

  // Remove cells to create puzzle
  void _removeCells(int count) {
    Random rnd = Random();
    int removed = 0;

    while (removed < count) {
      int r = rnd.nextInt(9);
      int c = rnd.nextInt(9);

      if (board[r][c] != 0) {
        board[r][c] = 0;
        removed++;
      }
    }

    // mark fixed cells (non-zero)
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        fixed[r][c] = board[r][c] != 0;
      }
    }
  }

  //clear board
  void clearBoard() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (!fixed[r][c]) {
          board[r][c] = 0;
        }
      }
    }
    selectedRow = null;
    selectedCol = null;
    notifyListeners();
  }

  //new game
  void newGame() {
    generatePuzzle();
    selectedRow = null;
    selectedCol = null;
    notifyListeners();
  }

  //complete check
  bool isComplete() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (board[r][c] == 0 || mistakeAt(r, c)) {
          return false; // empty cell or mistake found
        }
      }
    }
    return true;
  }
}
