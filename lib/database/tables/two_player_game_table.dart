class TwoPlayerGameTable {
  static const String tableName = 'two_player_score';

  static const String createTable = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      player1_name TEXT,
      player2_name TEXT,
      result TEXT,
      played_at TEXT
    )
  ''';
}