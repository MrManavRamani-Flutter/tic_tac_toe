import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/two_player_game_model.dart';
import '../../../providers/connectivity_provider.dart';
import '../../../providers/two_player_game_provider.dart';
import '../../auth_screens/no_internet_screen.dart';
import 'two_player_results_screen.dart';

class TicTacToeTwoPlayerGameScreen extends StatefulWidget {
  final String boardSize;
  final String player1Name;
  final String player2Name;

  const TicTacToeTwoPlayerGameScreen({
    super.key,
    required this.boardSize,
    required this.player1Name,
    required this.player2Name,
  });

  @override
  TicTacToeTwoPlayerGameScreenState createState() =>
      TicTacToeTwoPlayerGameScreenState();
}

class TicTacToeTwoPlayerGameScreenState
    extends State<TicTacToeTwoPlayerGameScreen> {
  late int gridSize;
  late List<String> board;
  bool isPlayerOneTurn = true;
  bool gameOver = false;
  String winner = "";

  @override
  void initState() {
    super.initState();
    gridSize = _getGridSize(widget.boardSize);
    board = List.filled(gridSize * gridSize, "");
  }

  int _getGridSize(String boardSize) => int.parse(boardSize.split('x')[0]);

  void _onCellTap(int index) {
    if (board[index] != "" || gameOver) return;

    setState(() {
      board[index] = isPlayerOneTurn ? "X" : "O";
      if (_checkWinner(isPlayerOneTurn ? "X" : "O")) {
        winner = isPlayerOneTurn ? widget.player1Name : widget.player2Name;
        gameOver = true;
      } else if (_isBoardFull()) {
        winner = "It's a Draw!";
        gameOver = true;
      } else {
        isPlayerOneTurn = !isPlayerOneTurn;
      }

      if (gameOver) {
        _saveGameResult();
        _navigateToResultsScreen();
      }
    });
  }

  bool _checkWinner(String player) {
    for (int i = 0; i < gridSize; i++) {
      if (List.generate(gridSize, (j) => board[i * gridSize + j])
              .every((cell) => cell == player) ||
          List.generate(gridSize, (j) => board[j * gridSize + i])
              .every((cell) => cell == player)) {
        return true;
      }
    }
    if (List.generate(gridSize, (i) => board[i * (gridSize + 1)])
            .every((cell) => cell == player) ||
        List.generate(gridSize, (i) => board[(gridSize - 1) * (i + 1)])
            .every((cell) => cell == player)) {
      return true;
    }
    return false;
  }

  bool _isBoardFull() => board.every((cell) => cell != "");

  void _saveGameResult() async {
    final gameProvider =
        Provider.of<TwoPlayerGameProvider>(context, listen: false);
    await gameProvider.addGame(TwoPlayerGame(
      player1Name: widget.player1Name,
      player2Name: widget.player2Name,
      result: winner == "It's a Draw!" ? "Draw" : winner,
      playedAt: DateTime.now(),
    ));
  }

  void _navigateToResultsScreen() {
    final String resultMessage = winner == "It's a Draw!"
        ? "It's a Draw!"
        : "$winner Wins!\n${winner.contains(widget.player1Name) ? widget.player2Name : widget.player1Name} Loses!";
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TwoPlayerResultsScreen(
          player1Name: widget.player1Name,
          player2Name: widget.player2Name,
          winnerMessage: resultMessage,
          boardSize: widget.boardSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isSplitScreen = screenSize.height < 600; // Detect split-screen

    return !connectivityProvider.isConnected
        ? const NoInternetScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Tic Tac Toe",
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                padding: EdgeInsets.all(isSplitScreen ? 8.0 : 16.0),
                // Responsive padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeadingSection(
                      player1Name: widget.player1Name,
                      player2Name: widget.player2Name,
                      isPlayerOneTurn: isPlayerOneTurn,
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
  final String player1Name, player2Name;
  final bool isPlayerOneTurn;
  final double screenHeight;

  const HeadingSection({
    super.key,
    required this.player1Name,
    required this.player2Name,
    required this.isPlayerOneTurn,
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PlayerInfo(
          label: player1Name,
          icon: "X",
          isActive: isPlayerOneTurn,
          textScale: textScale,
          avatarRadius: avatarRadius,
        ),
        PlayerInfo(
          label: player2Name,
          icon: "O",
          isActive: !isPlayerOneTurn,
          textScale: textScale,
          avatarRadius: avatarRadius,
        ),
      ],
    );
  }
}

class PlayerInfo extends StatelessWidget {
  final String label, icon;
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
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16 * textScale, // Responsive text size
              ),
        ),
        SizedBox(height: 10 * textScale), // Responsive spacing
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor:
              isActive ? Theme.of(context).colorScheme.secondary : Colors.grey,
          child: Text(
            icon,
            style: TextStyle(
              fontSize: 32 * textScale, // Scale font size
              color: Colors.white,
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
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            blurRadius: 10,
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
        itemBuilder: (_, index) => GestureDetector(
          onTap: () => onCellTap(index),
          child: Container(
            margin: EdgeInsets.all(isSplitScreen ? 2 : 4),
            // Responsive margin
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Text(
                board[index],
                style: TextStyle(
                  fontSize: isSplitScreen ? 24 : 32,
                  // Smaller font in split-screen
                  fontWeight: FontWeight.bold,
                  color: board[index] == "X"
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
