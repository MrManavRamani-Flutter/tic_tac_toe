import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ads/ad_provider.dart'; // Import AdProvider for banner ads
import '../../../providers/connectivity_provider.dart';
import '../../auth_screens/no_internet_screen.dart';
import 'score_screen.dart';
import 'ttt_game_screen.dart';

class ResultsScreen extends StatelessWidget {
  final String result;
  final String previousBoardSize;
  final String previousDifficulty;

  const ResultsScreen({
    super.key,
    required this.result,
    required this.previousBoardSize,
    required this.previousDifficulty,
  });

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final adProvider = Provider.of<AdProvider>(context); // Access AdProvider

    return !connectivityProvider.isConnected
        ? const NoInternetScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Game Over'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.scoreboard_outlined),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScoreScreen()),
                  ),
                ),
              ],
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
              child: Column(
                children: [
                  // Centered Content
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            result,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Back to Setup'),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TicTacToeGameScreen(
                                    boardSize: previousBoardSize,
                                    difficulty: previousDifficulty,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Play Again'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Banner Ad
                  adProvider.getResultsBottomBannerAdWidget(),
                ],
              ),
            ),
          );
  }
}
