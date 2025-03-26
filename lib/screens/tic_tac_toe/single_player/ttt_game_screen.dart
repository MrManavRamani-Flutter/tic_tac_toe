import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ads/ad_provider.dart'; // Import AdProvider for interstitial ad
import '../../../providers/connectivity_provider.dart';
import '../../../providers/score_provider.dart'; // Import ScoreProvider to manage scores
import '../../auth_screens/no_internet_screen.dart';
import 'results_screen.dart';

class TicTacToeGameScreen extends StatefulWidget {
  final String boardSize;
  final String difficulty;

  const TicTacToeGameScreen({
    super.key,
    required this.boardSize,
    required this.difficulty,
  });

  @override
  TicTacToeGameScreenState createState() => TicTacToeGameScreenState();
}

class TicTacToeGameScreenState extends State<TicTacToeGameScreen> {
  late int gridSize;
  late List<String> board;
  bool gameOver = false;
  String winner = "";
  bool _hasShownResults = false;

  @override
  void initState() {
    super.initState();
    gridSize = _getGridSize();
    board = List.filled(gridSize * gridSize, ""); // Initialize the board
  }

  int _getGridSize() {
    switch (widget.boardSize) {
      case '3x3':
        return 3;
      case '4x4':
        return 4;
      case '5x5':
        return 5;
      default:
        return 3; // Default to 3x3 if no valid size is provided
    }
  }

  void _onCellTap(int index) {
    if (board[index].isNotEmpty || gameOver) return;

    setState(() {
      board[index] = "X"; // Player's move
      if (_checkWinner("X")) {
        winner = "You Win!";
        gameOver = true;
      } else if (_isBoardFull()) {
        winner = "It's a Draw!";
        gameOver = true;
      } else {
        Future.delayed(const Duration(milliseconds: 500), _computerMove);
      }
    });

    if (gameOver) {
      _handleGameOver();
    }
  }

  void _computerMove() {
    if (gameOver) return;

    int aiMove = _getAIMove();

    if (aiMove != -1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          board[aiMove] = "O"; // AI's move
          if (_checkWinner("O")) {
            winner = "Computer Wins!";
            gameOver = true;
          } else if (_isBoardFull()) {
            winner = "It's a Draw!";
            gameOver = true;
          }
        });

        if (gameOver) {
          _handleGameOver();
        }
      });
    }
  }

  int _getAIMove() {
    List<int> emptyCells = List.generate(board.length, (index) => index)
        .where((index) => board[index].isEmpty)
        .toList();

    switch (widget.difficulty) {
      case 'Easy':
        return _easyAIMove(emptyCells);
      case 'Medium':
        return _mediumAIMove(emptyCells);
      case 'Hard':
        return _hardAIMove(emptyCells);
      default:
        return -1;
    }
  }

  int _easyAIMove(List<int> emptyCells) {
    if (Random().nextInt(100) < 69) {
      return _tryWinningMove("O", emptyCells) ?? _selectRandomMove(emptyCells);
    }
    if (Random().nextInt(100) < 29) {
      return _tryBlockingMove("X", emptyCells) ?? _selectRandomMove(emptyCells);
    }
    return _selectRandomMove(emptyCells);
  }

  int _mediumAIMove(List<int> emptyCells) {
    if (Random().nextInt(100) < 40) {
      return _tryWinningMove("O", emptyCells) ?? _selectRandomMove(emptyCells);
    }
    if (Random().nextInt(100) < 55) {
      return _tryBlockingMove("X", emptyCells) ?? _selectRandomMove(emptyCells);
    }
    return _selectRandomMove(emptyCells);
  }

  int _hardAIMove(List<int> emptyCells) {
    int? winningMove = _tryWinningMove("O", emptyCells);
    if (winningMove != null) {
      return winningMove; // Return if we found a winning move
    }

    int? blockingMove = _tryBlockingMove("X", emptyCells);
    if (blockingMove != null) {
      return blockingMove; // Return if we found a blocking move
    }

    return _selectRandomMove(
        emptyCells); // Play a random move if no high-priority moves available
  }

  int? _tryWinningMove(String player, List<int> emptyCells) {
    for (int cell in emptyCells) {
      board[cell] = player;
      if (_checkWinner(player)) {
        board[cell] = ""; // Undo move
        return cell; // Winning move found
      }
      board[cell] = ""; // Undo move
    }
    return null; // No winning move found
  }

  int? _tryBlockingMove(String player, List<int> emptyCells) {
    for (int cell in emptyCells) {
      board[cell] = player; // Try the move
      if (_checkWinner(player)) {
        board[cell] = ""; // Undo move
        return cell; // Blocking move found
      }
      board[cell] = ""; // Undo move
    }
    return null; // No blocking move found
  }

  int _selectRandomMove(List<int> emptyCells) {
    return emptyCells.isEmpty
        ? -1
        : emptyCells[Random().nextInt(emptyCells.length)];
  }

  bool _checkWinner(String player) {
    for (int row = 0; row < gridSize; row++) {
      if (board
          .sublist(row * gridSize, row * gridSize + gridSize)
          .every((cell) => cell == player)) {
        return true;
      }
    }
    for (int col = 0; col < gridSize; col++) {
      if (List.generate(gridSize, (index) => board[col + index * gridSize])
          .every((cell) => cell == player)) {
        return true;
      }
    }
    return List.generate(gridSize, (index) => board[index * (gridSize + 1)])
            .every((cell) => cell == player) ||
        List.generate(gridSize, (index) => board[(gridSize - 1) * (index + 1)])
            .every((cell) => cell == player);
  }

  bool _isBoardFull() => board.every((cell) => cell.isNotEmpty);

  void _handleGameOver() {
    if (gameOver && !_hasShownResults) {
      _hasShownResults = true;
      _showInterstitialAdAndProceed();
    }
  }

  void _showInterstitialAdAndProceed() {
    final adProvider = Provider.of<AdProvider>(context, listen: false);
    adProvider.showInterstitialAd(() async {
      // Callback after ad is dismissed or fails
      await _updateScoreAfterGame();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              result: winner,
              previousBoardSize: widget.boardSize,
              previousDifficulty: widget.difficulty,
            ),
          ),
        );
      }
    });
  }

  Future<void> _updateScoreAfterGame() async {
    final scoreProvider = context.read<ScoreProvider>();

    // Always update the existing score record
    if (winner == "You Win!") {
      await scoreProvider.updateScore(win: true, loss: false, draw: false);
    } else if (winner == "Computer Wins!") {
      await scoreProvider.updateScore(win: false, loss: true, draw: false);
    } else if (winner == "It's a Draw!") {
      await scoreProvider.updateScore(win: false, loss: false, draw: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    return !connectivityProvider.isConnected
        ? const NoInternetScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Tic Tac Toe'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const HeadingSection(),
                    const SizedBox(height: 20),
                    GameBoard(
                      board: board,
                      gridSize: gridSize,
                      onCellTap: _onCellTap,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class HeadingSection extends StatelessWidget {
  const HeadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PlayerInfo(label: "You (X)", icon: "X", isActive: true),
        PlayerInfo(label: "Bot (O)", icon: "O", isActive: false),
      ],
    );
  }
}

class PlayerInfo extends StatelessWidget {
  final String label;
  final String icon;
  final bool isActive;

  const PlayerInfo({
    super.key,
    required this.label,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 10),
        CircleAvatar(
          radius: 30,
          backgroundColor:
              isActive ? Theme.of(context).primaryColor : Colors.grey,
          child: Text(
            icon,
            style: TextStyle(
              fontFamily: 'ComicSansMS',
              fontSize: 32,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class GameBoard extends StatelessWidget {
  final List<String> board;
  final int gridSize;
  final Function(int) onCellTap;

  const GameBoard({
    super.key,
    required this.board,
    required this.gridSize,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    double boardSize = MediaQuery.of(context).size.width * 0.85;

    return Container(
      width: boardSize,
      height: boardSize,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          childAspectRatio: 1,
        ),
        itemCount: gridSize * gridSize,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onCellTap(index),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  board[index],
                  style: TextStyle(
                    fontFamily: 'ComicSansMS',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: board[index] == "X"
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
