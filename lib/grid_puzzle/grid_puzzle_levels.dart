// lib/grid_puzzle/grid_puzzle_levels.dart
///
/// Level data for Grid Puzzle.
/// Each level is a List<List<int?>> where:
///   - int value = active cell with that value
///   - null     = inactive cell (invisible, non-interactive)
///
class GridPuzzleLevels {
  static final List<List<List<int?>>> levels = [
    // Level 1
    [
      [null, -1,  null],
      [-1,   1,  -1],
      [null, -1,  null],
    ],

    // Level 2
    [
      [null, null,  1],
      [null,   0,  null],
      [-1,   null, null],
    ],

    // Level 3
    [
      [ 1,  null,  2],
      [null, -10, null],
      [ 3,  null,  4],
    ],

    // Level 4
    [
      [ 8,  null,  8],
      [null, -24,  8],
      [ 8,   0,    0],
    ],

    // Level 5
    [
      [ 7, -7,  2],
      [-8, -8, -3],
      [-1,  2,  0],
    ],

    // Level 6
    [
      [-5, 3, -4],
      [5, -3, -2],
      [-5, -9, 8],
    ],

    // Level 7
    [
      [-4, null, null],
      [2, 0, -2],
      [0, null, null],
    ],

    // Level 8
    [
      [0, -12, 0],
      [8, -4, 8],
      [-4, -8, -4],
    ],

    // Level 9
    [
      [-6, -1, 4],
      [-9, null, -22],
      [-12, 6, -3],
    ],

    // Level 10
    [
      [-6, -1, -8],
      [4, -8, 7],
      [-5, -11, -9],
    ],
  ];

  static int get totalLevels => levels.length;

  static List<List<int?>> level(int index) {
    return levels[index]
        .map((row) => List<int?>.from(row))
        .toList(); // defensive copy
  }
}
