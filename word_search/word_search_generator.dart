import 'dart:math';

//store the final generated search grid and list of successfully placed word
class WordSearchResult {
  final List<List<String>> grid;
  final List<String> placedWords;

  WordSearchResult(this.grid, this.placedWords);
}

//main class that generate the word search puzzle
class WordSearchGenerator {
  final Random _rand = Random();

  WordSearchResult generate(List<String> words, int size) {
    // Prepare empty board
    List<List<String>> board = List.generate(size, (_) => List.generate(size, (_) => ''));

    List<String> placedWords = [];

    for (String word in words) {
      word = word.toUpperCase();
      if (word.length > size) continue;

      bool placed = _placeWord(board, word);
      if (placed) placedWords.add(word);
    }

    // Fill empty cells with random letters with random letters A-Z
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (board[r][c] == '') {
          board[r][c] = String.fromCharCode(_rand.nextInt(26) + 65);
        }
      }
    }

    return WordSearchResult(board, placedWords);
  }

  //attempt to place a single word on the board
  bool _placeWord(List<List<String>> board, String word) {
    int size = board.length;
    int attempts = 50; // increased attempts to fit more words

    while (attempts-- > 0) {
      //randomly choose horizontal or vertical placement
      bool horizontal = _rand.nextBool();
      int row = _rand.nextInt(size);
      int col = _rand.nextInt(size);

      //pick a random starting point
      if (horizontal && col + word.length > size) continue;
      if (!horizontal && row + word.length > size) continue;

      bool ok = true;

      //if the word does fit in the direction it then skip
      for (int i = 0; i < word.length; i++) {
        int r = row + (horizontal ? 0 : i);
        int c = col + (horizontal ? i : 0);
        //a cell must be empty or match the letter that being place (for overlapping)
        if (board[r][c] != '' && board[r][c] != word[i]) {
          ok = false;
          break;
        }
      }

      if (!ok) continue;

      //Place the word into the grid
      for (int i = 0; i < word.length; i++) {
        int r = row + (horizontal ? 0 : i);
        int c = col + (horizontal ? i : 0);
        board[r][c] = word[i];
      }

      //return true if a word is successfully added
      return true;
    }

    //return false if a word can't be place
    return false;
  }
}
