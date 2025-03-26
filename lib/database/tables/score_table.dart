class ScoreTable {
  static const String tableName = 'single_player_score';

  static const String createTable = '''
    CREATE TABLE $tableName (
      spc_id INTEGER PRIMARY KEY AUTOINCREMENT,
      win INTEGER DEFAULT 0,
      loss INTEGER DEFAULT 0,
      draw INTEGER DEFAULT 0
    )
  ''';
}
