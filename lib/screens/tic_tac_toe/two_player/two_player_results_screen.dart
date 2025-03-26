import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/connectivity_provider.dart';
import '../../auth_screens/no_internet_screen.dart';
import 'two_player_game_screen.dart';
import 'two_player_score_screen.dart';

class TwoPlayerResultsScreen extends StatelessWidget {
  final String player1Name, player2Name, winnerMessage, boardSize;

  const TwoPlayerResultsScreen({
    super.key,
    required this.player1Name,
    required this.player2Name,
    required this.winnerMessage,
    required this.boardSize, // Add boardSize parameter
  });

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(
        context); // Access ConnectivityProvider
    return !connectivityProvider.isConnected
        ? const NoInternetScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Game Results",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.scoreboard_outlined),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TwoPlayerScoreScreen())),
                ),
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(winnerMessage,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontSize: 28),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.popUntil(context, (route) => route.isFirst),
                      child: const Text("Back to Home"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicTacToeTwoPlayerGameScreen(
                              boardSize: boardSize,
                              player1Name: player1Name,
                              player2Name: player2Name,
                            ),
                          ),
                        );
                      },
                      child: const Text("Play Again"),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
