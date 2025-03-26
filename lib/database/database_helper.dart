import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/score_model.dart';
import '../models/two_player_game_model.dart';
import 'tables/score_table.dart';
import 'tables/two_player_game_table.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'tic_tac_toe.db');
    log('[log] DatabaseHelper: Initializing database at $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        log('[log] DatabaseHelper: Creating tables...');
        await db.execute(ScoreTable.createTable);
        await db.execute(TwoPlayerGameTable.createTable);

        // Insert default score record only if none exists
        final existingScores = await db.query(ScoreTable.tableName);
        if (existingScores.isEmpty) {
          await db.insert(
            ScoreTable.tableName,
            Score(win: 0, loss: 0, draw: 0).toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          log('[log] DatabaseHelper: Default score inserted (win: 0, loss: 0, draw: 0)');
        }
        log('[log] DatabaseHelper: Tables created successfully.');
      },
      onOpen: (db) {
        log('[log] DatabaseHelper: Database opened.');
      },
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
      log('[log] DatabaseHelper: Database closed.');
    }
  }

  Future<void> insertTwoPlayerGame(TwoPlayerGame game) async {
    final db = await database;
    log('[log] DatabaseHelper: Inserting two-player game: ${game.toMap()}');
    try {
      await db.insert(
        TwoPlayerGameTable.tableName,
        game.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log('[log] DatabaseHelper: Two-player game inserted successfully.');
    } catch (e) {
      log('[log] DatabaseHelper: Error inserting two-player game: $e');
      rethrow; // Propagate the error to the caller
    }
  }

  Future<List<TwoPlayerGame>> getTwoPlayerGames() async {
    final db = await database;
    log('[log] DatabaseHelper: Fetching two-player games...');
    try {
      final List<Map<String, dynamic>> maps =
          await db.query(TwoPlayerGameTable.tableName);
      log('[log] DatabaseHelper: Two-player games fetched: $maps');
      return maps.map((map) => TwoPlayerGame.fromMap(map)).toList();
    } catch (e) {
      log('[log] DatabaseHelper: Error fetching two-player games: $e');
      rethrow; // Propagate the error
    }
  }

  Future<void> insertScore(Score score) async {
    final db = await database;
    log('[log] DatabaseHelper: Inserting score: ${score.toMap()}');
    try {
      await db.insert(
        ScoreTable.tableName,
        score.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log('[log] DatabaseHelper: Score inserted successfully.');
    } catch (e) {
      log('[log] DatabaseHelper: Error inserting score: $e');
      rethrow; // Propagate the error
    }
  }

  Future<void> updateScore({bool? win, bool? loss, bool? draw}) async {
    final db = await database;
    log('[log] DatabaseHelper: Querying current score...');
    try {
      final currentScore = await db.query(
        ScoreTable.tableName,
        where: 'spc_id = ?',
        whereArgs: [1], // Assuming spc_id 1 is the default single-player score
      );

      if (currentScore.isNotEmpty) {
        final score = currentScore.first;
        int currentWin = (score['win'] as int?) ?? 0;
        int currentLoss = (score['loss'] as int?) ?? 0;
        int currentDraw = (score['draw'] as int?) ?? 0;

        Map<String, dynamic> updatedValues = {};
        if (win == true) updatedValues['win'] = currentWin + 1;
        if (loss == true) updatedValues['loss'] = currentLoss + 1;
        if (draw == true) updatedValues['draw'] = currentDraw + 1;

        if (updatedValues.isNotEmpty) {
          log('[log] DatabaseHelper: Updating score with values: $updatedValues');
          await db.update(
            ScoreTable.tableName,
            updatedValues,
            where: 'spc_id = ?',
            whereArgs: [1],
          );
          log('[log] DatabaseHelper: Score updated successfully.');
        }
      } else {
        log('[log] DatabaseHelper: No existing score, inserting new score...');
        await insertScore(Score(
          spcId: 1, // Explicitly set spc_id to 1
          win: win == true ? 1 : 0,
          loss: loss == true ? 1 : 0,
          draw: draw == true ? 1 : 0,
        ));
      }
    } catch (e) {
      log('[log] DatabaseHelper: Error updating score: $e');
      rethrow; // Propagate the error
    }
  }

  Future<List<Score>> getScores() async {
    final db = await database;
    log('[log] DatabaseHelper: Fetching scores...');
    try {
      final List<Map<String, dynamic>> maps =
          await db.query(ScoreTable.tableName);
      log('[log] DatabaseHelper: Scores fetched: $maps');
      return maps.map((map) => Score.fromMap(map)).toList();
    } catch (e) {
      log('[log] DatabaseHelper: Error fetching scores: $e');
      rethrow; // Propagate the error
    }
  }
}
