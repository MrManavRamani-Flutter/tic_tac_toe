import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ads/ad_provider.dart'; // Import AdProvider for banner ads
import '../../../providers/connectivity_provider.dart';
import '../../../providers/score_provider.dart';
import '../../auth_screens/no_internet_screen.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  ScoreScreenState createState() => ScoreScreenState();
}

class ScoreScreenState extends State<ScoreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('[log] ScoreScreen: Fetching scores on init...');
      context.read<ScoreProvider>().fetchScores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scoreProvider = context.watch<ScoreProvider>();
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final adProvider = Provider.of<AdProvider>(context); // Access AdProvider
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    int wins = 0;
    int losses = 0;
    int draws = 0;

    if (scoreProvider.scores.isNotEmpty) {
      final score =
          scoreProvider.scores.first; // Take the first (and assumed only) score
      wins = score.win;
      losses = score.loss;
      draws = score.draw;
      log('[log] ScoreScreen: Displaying scores - Wins: $wins, Losses: $losses, Draws: $draws');
    } else {
      log('[log] ScoreScreen: No scores available.');
    }

    return !connectivityProvider.isConnected
        ? const NoInternetScreen()
        : Scaffold(
      appBar: AppBar(
        title: const Text('Single Player Scores'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
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
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Your Scoreboard',
                        style: Theme.of(context).textTheme.displayLarge),
                    const SizedBox(height: 30),
                    Container(
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
                      child: Column(
                        children: [
                          _buildScoreTile("Wins", wins, Colors.green),
                          const SizedBox(height: 20),
                          _buildScoreTile("Losses", losses, Colors.red),
                          const SizedBox(height: 20),
                          _buildScoreTile("Draws", draws, Colors.orange),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Bottom Banner Ad
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50, // Adjust height as needed
                  child: adProvider.getScoreBottomBannerAdWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreTile(String label, int score, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: color, size: 32),
              const SizedBox(width: 16),
              Text(label, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          Text(
            score.toString(),
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: color, fontSize: 24),
          ),
        ],
      ),
    );
  }
}