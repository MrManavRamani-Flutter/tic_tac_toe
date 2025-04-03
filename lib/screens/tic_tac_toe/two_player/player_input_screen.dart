import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ads/ad_provider.dart';
import '../../../providers/connectivity_provider.dart';
import '../../auth_screens/no_internet_screen.dart';
import 'two_player_game_screen.dart';
import 'two_player_score_screen.dart';

class PlayerVsPlayerScreen extends StatefulWidget {
  const PlayerVsPlayerScreen({super.key});

  @override
  PlayerVsPlayerScreenState createState() => PlayerVsPlayerScreenState();
}

class PlayerVsPlayerScreenState extends State<PlayerVsPlayerScreen> {
  final TextEditingController _player1Controller = TextEditingController(text: 'Player 1');
  final TextEditingController _player2Controller = TextEditingController(text: 'Player 2');
  String _selectedBoardSize = '3x3';

  void _startGame() {
    if (_player1Controller.text.length < 3) {
      _showSnackBar('Player 1 name must be at least 3 characters!');
      return;
    }
    if (_player2Controller.text.length < 3) {
      _showSnackBar('Player 2 name must be at least 3 characters!');
      return;
    }

    String player1Name = _player1Controller.text.isNotEmpty ? _player1Controller.text : 'Player 1';
    String player2Name = _player2Controller.text.isNotEmpty ? _player2Controller.text : 'Player 2';

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TicTacToeTwoPlayerGameScreen(
            boardSize: _selectedBoardSize,
            player1Name: player1Name,
            player2Name: player2Name,
          ),
        ),
      );
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final adProvider = Provider.of<AdProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isSplitScreen = screenSize.height < 600; // Detect split-screen

    return !connectivityProvider.isConnected
        ? const NoInternetScreen()
        : Scaffold(
      appBar: AppBar(
        title: const Text('Two Player Setup'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        toolbarHeight: screenSize.height * 0.1, // Responsive AppBar height
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isSplitScreen ? 12.0 : 24.0), // Responsive padding
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tic Tac Toe',
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: isSplitScreen ? 28 : 36, // Responsive title size
                        ),
                      ),
                      SizedBox(height: isSplitScreen ? 15 : 30), // Responsive spacing
                      _buildSetupCard(context, screenSize, isSplitScreen),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Banner Ad
            adProvider.getTwoPlayerSetupBottomBannerAdWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupCard(BuildContext context, Size screenSize, bool isSplitScreen) {
    return Container(
      width: screenSize.width * 0.9, // 90% of screen width
      padding: EdgeInsets.all(isSplitScreen ? 10 : 20), // Responsive padding
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField('Player 1 Name', _player1Controller, isSplitScreen),
          SizedBox(height: isSplitScreen ? 10 : 20),
          _buildTextField('Player 2 Name', _player2Controller, isSplitScreen),
          SizedBox(height: isSplitScreen ? 10 : 20),
          _buildDropdown(
            "Board Size",
            _selectedBoardSize,
            ['3x3', '4x4', '5x5'],
                (value) => setState(() => _selectedBoardSize = value!),
            Icons.grid_view,
            isSplitScreen,
          ),
          SizedBox(height: isSplitScreen ? 15 : 30),
          ElevatedButton(
            onPressed: _startGame,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: isSplitScreen ? 20 : 30,
                vertical: isSplitScreen ? 10 : 15,
              ),
            ),
            child: Text(
              'Play Now',
              style: TextStyle(fontSize: isSplitScreen ? 14 : 16),
            ),
          ),
          SizedBox(height: isSplitScreen ? 10 : 20),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TwoPlayerScoreScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              padding: EdgeInsets.symmetric(
                horizontal: isSplitScreen ? 20 : 30,
                vertical: isSplitScreen ? 10 : 15,
              ),
            ),
            child: Text(
              'View Scores',
              style: TextStyle(fontSize: isSplitScreen ? 14 : 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isSplitScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: isSplitScreen ? 14 : 16, // Responsive text size
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
            color: Theme.of(context).cardColor,
          ),
          child: TextField(
            controller: controller,
            maxLength: 20,
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
            style: TextStyle(fontSize: isSplitScreen ? 14 : 16), // Responsive input text
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
      String label,
      String value,
      List<String> options,
      Function(String?) onChanged,
      IconData icon,
      bool isSplitScreen,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: isSplitScreen ? 14 : 16,
          ),
        ),
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
              prefixIcon: Icon(icon, color: Theme.of(context).primaryColor, size: isSplitScreen ? 20 : 24),
              border: InputBorder.none,
            ),
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontSize: isSplitScreen ? 14 : 16,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}