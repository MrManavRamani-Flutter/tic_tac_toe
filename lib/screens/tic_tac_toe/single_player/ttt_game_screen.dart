import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ads/ad_provider.dart';
import '../../../providers/connectivity_provider.dart';
import '../../../providers/score_provider.dart';
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
  bool isPlayerTurn = true; // New flag to track whose turn it is
  bool isProcessing = false; // New flag to prevent multiple clicks

  @override
  void initState() {
    super.initState();
    gridSize = _getGridSize();
    board = List.filled(gridSize * gridSize, "");
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
        return 3;
    }
  }

  void _onCellTap(int index) {
    if (!isPlayerTurn || isProcessing || board[index].isNotEmpty || gameOver) {
      return;
    }

    setState(() {
      isProcessing = true; // Lock input
      board[index] = "X";
      if (_checkWinner("X")) {
        winner = "You Win!";
        gameOver = true;
      } else if (_isBoardFull()) {
        winner = "It's a Draw!";
        gameOver = true;
      }
    });

    if (gameOver) {
      _handleGameOver();
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          isPlayerTurn = false; // Switch to AI's turn
          isProcessing = false; // Unlock after player's move is processed
        });
        _computerMove();
      });
    }
  }

  void _computerMove() {
    if (gameOver) return;

    int aiMove = _getAIMove();

    if (aiMove != -1) {
      setState(() {
        isProcessing = true; // Lock input during AI move
        board[aiMove] = "O";
        if (_checkWinner("O")) {
          winner = "Computer Wins!";
          gameOver = true;
        } else if (_isBoardFull()) {
          winner = "It's a Draw!";
          gameOver = true;
        }
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          isPlayerTurn = true; // Switch back to player's turn
          isProcessing = false; // Unlock for next player move
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
    if (winningMove != null) return winningMove;

    int? blockingMove = _tryBlockingMove("X", emptyCells);
    if (blockingMove != null) return blockingMove;

    return _selectRandomMove(emptyCells);
  }

  int? _tryWinningMove(String player, List<int> emptyCells) {
    for (int cell in emptyCells) {
      board[cell] = player;
      if (_checkWinner(player)) {
        board[cell] = "";
        return cell;
      }
      board[cell] = "";
    }
    return null;
  }

  int? _tryBlockingMove(String player, List<int> emptyCells) {
    for (int cell in emptyCells) {
      board[cell] = player;
      if (_checkWinner(player)) {
        board[cell] = "";
        return cell;
      }
      board[cell] = "";
    }
    return null;
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
    final screenSize = MediaQuery.of(context).size;
    final isSplitScreen =
        screenSize.height < 600; // Threshold for split-screen detection

    return !connectivityProvider.isConnected
        ? const NoInternetScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Tic Tac Toe'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              toolbarHeight:
                  screenSize.height * 0.1, // Responsive AppBar height
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
                padding: EdgeInsets.all(
                  isSplitScreen ? 8.0 : 16.0, // Reduced padding in split-screen
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeadingSection(
                      isPlayerTurn: isPlayerTurn,
                      screenHeight: screenSize.height,
                    ),
                    SizedBox(
                        height: isSplitScreen ? 10 : 20), // Responsive spacing
                    GameBoard(
                      board: board,
                      gridSize: gridSize,
                      onCellTap: _onCellTap,
                      screenSize: screenSize,
                      isSplitScreen: isSplitScreen,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class HeadingSection extends StatelessWidget {
  final bool isPlayerTurn;
  final double screenHeight;

  const HeadingSection({
    super.key,
    required this.isPlayerTurn,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isSplitScreen = screenHeight < 600;
    final textScale =
        isSplitScreen ? 0.8 : 1.0; // Scale down text in split-screen
    final avatarRadius =
        isSplitScreen ? 20.0 : 30.0; // Smaller avatar in split-screen

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PlayerInfo(
          label: "You (X)",
          icon: "X",
          isActive: isPlayerTurn,
          textScale: textScale,
          avatarRadius: avatarRadius,
        ),
        PlayerInfo(
          label: "Bot (O)",
          icon: "O",
          isActive: !isPlayerTurn,
          textScale: textScale,
          avatarRadius: avatarRadius,
        ),
      ],
    );
  }
}

class PlayerInfo extends StatelessWidget {
  final String label;
  final String icon;
  final bool isActive;
  final double textScale;
  final double avatarRadius;

  const PlayerInfo({
    super.key,
    required this.label,
    required this.icon,
    required this.isActive,
    required this.textScale,
    required this.avatarRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontSize: 16 * textScale), // Responsive text size
        ),
        SizedBox(height: 10 * textScale), // Responsive spacing
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor:
              isActive ? Theme.of(context).primaryColor : Colors.grey,
          child: Text(
            icon,
            style: TextStyle(
              fontFamily: 'ComicSansMS',
              fontSize: 32 * textScale, // Scale font size
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
  final Size screenSize;
  final bool isSplitScreen;

  const GameBoard({
    super.key,
    required this.board,
    required this.gridSize,
    required this.onCellTap,
    required this.screenSize,
    required this.isSplitScreen,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate board size based on screen dimensions
    final maxBoardWidth = screenSize.width * 0.85;
    final maxBoardHeight =
        screenSize.height * 0.6; // Limit height to 60% of screen
    final boardSize = isSplitScreen
        ? maxBoardWidth < maxBoardHeight
            ? maxBoardWidth
            : maxBoardHeight
        : maxBoardWidth; // Use smaller dimension in split-screen

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
              margin: EdgeInsets.all(isSplitScreen ? 2 : 4),
              // Responsive margin
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
                    fontSize: isSplitScreen ? 32 : 40,
                    // Smaller font in split-screen
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
