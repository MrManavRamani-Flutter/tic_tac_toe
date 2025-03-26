import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ads/ad_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../auth_screens/no_internet_screen.dart';
import '../settings_screen/settings_screen.dart';
import 'single_player/game_settings_screen.dart';
import 'single_player/score_screen.dart';
import 'two_player/player_input_screen.dart';
import 'two_player/two_player_score_screen.dart';

class TttHomeScreen extends StatefulWidget {
  const TttHomeScreen({super.key});

  @override
  TttHomeScreenState createState() => TttHomeScreenState();
}

class TttHomeScreenState extends State<TttHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final adProvider = Provider.of<AdProvider>(context);

    return !connectivityProvider.isConnected
        ? const NoInternetScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Tic Tac Toe'),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  ).then((_) {}),
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
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ready to Play?',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(height: 40),
                          _buildGameButton(
                            context,
                            title: 'Player vs Bot',
                            icon: Icons.android,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GameSettingsScreen()),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildGameButton(
                            context,
                            title: 'High Scores (Bot)',
                            icon: Icons.score,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ScoreScreen()),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildGameButton(
                            context,
                            title: 'Player vs Player',
                            icon: Icons.people,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PlayerVsPlayerScreen()),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildGameButton(
                            context,
                            title: 'High Scores (PvP)',
                            icon: Icons.score,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TwoPlayerScoreScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  adProvider.getHomeBottomBannerAdWidget(),
                ],
              ),
            ),
          );
  }

  Widget _buildGameButton(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: 250,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
