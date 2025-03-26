class TwoPlayerGame {
  final String player1Name;
  final String player2Name;
  final String result;
  final DateTime playedAt;

  TwoPlayerGame({
    required this.player1Name,
    required this.player2Name,
    required this.result,
    required this.playedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'player1_name': player1Name,
      'player2_name': player2Name,
      'result': result,
      'played_at': playedAt.toIso8601String(),
    };
  }

  static TwoPlayerGame fromMap(Map<String, dynamic> map) {
    return TwoPlayerGame(
      player1Name: map['player1_name'],
      player2Name: map['player2_name'],
      result: map['result'],
      playedAt: DateTime.parse(map['played_at']),
    );
  }
}
