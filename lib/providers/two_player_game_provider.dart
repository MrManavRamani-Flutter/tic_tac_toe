import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/two_player_game_model.dart';

class TwoPlayerGameProvider with ChangeNotifier {
  List<TwoPlayerGame> _games = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<TwoPlayerGame> get games => _games;

  Future<void> loadGames() async {
    _games = await _databaseHelper.getTwoPlayerGames();
    notifyListeners();
  }

  Future<void> addGame(TwoPlayerGame twoPlayerGame) async {
    final newGame = TwoPlayerGame(
      player1Name: twoPlayerGame.player1Name,
      player2Name: twoPlayerGame.player2Name,
      result: twoPlayerGame.result,
      playedAt: twoPlayerGame.playedAt,
    );

    await _databaseHelper.insertTwoPlayerGame(newGame);
    _games.add(newGame);
    notifyListeners();
  }
}
