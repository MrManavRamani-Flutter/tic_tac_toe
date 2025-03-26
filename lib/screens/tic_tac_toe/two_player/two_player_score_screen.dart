import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../ads/ad_provider.dart'; // Import AdProvider for banner ads
import '../../../models/two_player_game_model.dart';
import '../../../providers/connectivity_provider.dart';
import '../../../providers/two_player_game_provider.dart';
import '../../auth_screens/no_internet_screen.dart';

class TwoPlayerScoreScreen extends StatefulWidget {
  const TwoPlayerScoreScreen({super.key});

  @override
  TwoPlayerScoreScreenState createState() => TwoPlayerScoreScreenState();
}

class TwoPlayerScoreScreenState extends State<TwoPlayerScoreScreen> {
  bool _isLoading = true;
  List<TwoPlayerGame>? _games;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    final gameProvider =
        Provider.of<TwoPlayerGameProvider>(context, listen: false);
    await gameProvider.loadGames();
    setState(() {
      _games = gameProvider.games;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final adProvider = Provider.of<AdProvider>(context); // Access AdProvider

    return !connectivityProvider.isConnected
        ? const NoInternetScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Two Player Scores'),
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
              child: Column(
                children: [
                  // Centered Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Game History',
                              style: Theme.of(context).textTheme.displayLarge),
                          const SizedBox(height: 30),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : _games?.isNotEmpty ?? false
                                      ? ListView.builder(
                                          itemCount: _games!.length,
                                          itemBuilder: (_, index) {
                                            TwoPlayerGame game = _games![index];
                                            String resultMessage = game.result
                                                        .toLowerCase() ==
                                                    "draw"
                                                ? "It's a Draw!"
                                                : "${game.result} wins against ${game.result.contains(game.player1Name) ? game.player2Name : game.player1Name}";
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd – kk:mm')
                                                    .format(game.playedAt);

                                            return _buildGameTile(
                                                resultMessage, formattedDate);
                                          },
                                        )
                                      : const Center(
                                          child: Text(
                                            "No data found for two-player game history",
                                            style: TextStyle(fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Banner Ad
                  adProvider.getTwoPlayerScoreBottomBannerAdWidget(),
                ],
              ),
            ),
          );
  }

  Widget _buildGameTile(String result, String date) {
    Color tileColor = result.contains("Draw")
        ? Colors.orange
        : result.contains("wins")
            ? Colors.green
            : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tileColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: tileColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: tileColor),
          ),
          const SizedBox(height: 8),
          Text(
            "Played on: $date",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
