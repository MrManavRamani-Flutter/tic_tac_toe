import 'dart:developer';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/score_model.dart';

class ScoreProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper;
  List<Score> _scores = [];

  ScoreProvider({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  List<Score> get scores => List.unmodifiable(_scores);

  Future<void> fetchScores() async {
    log('[log] ScoreProvider: Fetching scores...');
    try {
      _scores = await _databaseHelper.getScores();
      log('[log] ScoreProvider: Scores fetched successfully: $_scores');
      notifyListeners();
    } catch (e) {
      log('[log] ScoreProvider: Error fetching scores: $e');
    }
  }

  // Remove addScore since we only update the existing record
  // Future<void> addScore(Score score) async { ... }

  Future<void> updateScore({bool? win, bool? loss, bool? draw}) async {
    log('[log] ScoreProvider: Updating score - win: $win, loss: $loss, draw: $draw');
    try {
      await _databaseHelper.updateScore(win: win, loss: loss, draw: draw);
      await fetchScores();
      log('[log] ScoreProvider: Score updated successfully.');
    } catch (e) {
      log('[log] ScoreProvider: Error updating score: $e');
    }
  }
}
