import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ads/ad_provider.dart'; // Import AdProvider for banner ads
import '../../../providers/connectivity_provider.dart';
import '../../auth_screens/no_internet_screen.dart';
import 'score_screen.dart';
import 'ttt_game_screen.dart';

class GameSettingsScreen extends StatefulWidget {
  const GameSettingsScreen({super.key});

  @override
  GameSettingsScreenState createState() => GameSettingsScreenState();
}

class GameSettingsScreenState extends State<GameSettingsScreen> {
  String _selectedBoardSize = '3x3';
  String _selectedDifficulty = 'Easy';

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicTacToeGameScreen(
          boardSize: _selectedBoardSize,
          difficulty: _selectedDifficulty,
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options,
      Function(String?) onChanged, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
            color: Theme.of(context).cardColor,
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
              border: InputBorder.none,
            ),
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child:
                    Text(option, style: Theme.of(context).textTheme.labelLarge),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final adProvider = Provider.of<AdProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    return !connectivityProvider.isConnected
        ? const NoInternetScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Single Player Setup'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Stack(
              children: [
                // Background Gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
                // Scrollable Content with ListView
                ListView(
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  children: [
                    // Title
                    Center(
                      child: Text(
                        'Tic Tac Toe',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: isPortrait
                                      ? screenWidth * 0.1
                                      : screenWidth * 0.06,
                                ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Game Settings Box
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDropdown(
                            "Board Size",
                            _selectedBoardSize,
                            ['3x3', '4x4', '5x5'],
                            (value) =>
                                setState(() => _selectedBoardSize = value!),
                            Icons.grid_view,
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          _buildDropdown(
                            "Difficulty",
                            _selectedDifficulty,
                            ['Easy', 'Medium', 'Hard'],
                            (value) =>
                                setState(() => _selectedDifficulty = value!),
                            Icons.speed,
                          ),
                          SizedBox(height: screenHeight * 0.0375),
                          ElevatedButton(
                            onPressed: _startGame,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1,
                                vertical: screenHeight * 0.015,
                              ),
                            ),
                            child: const Text('Play Now'),
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ScoreScreen()),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1,
                                vertical: screenHeight * 0.015,
                              ),
                            ),
                            child: const Text('View Scores'),
                          ),
                        ],
                      ),
                    ),

                    // Ad Banner
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      height: screenHeight * 0.07,
                      width: double.infinity,
                      child: adProvider.getGameSettingsBottomBannerAdWidget(),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
