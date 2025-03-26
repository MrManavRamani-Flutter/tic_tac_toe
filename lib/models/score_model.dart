class Score {
  final int? spcId;
  final int win;
  final int loss;
  final int draw;

  Score({
    this.spcId,
    this.win = 0,
    this.loss = 0,
    this.draw = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'spc_id': spcId,
      'win': win,
      'loss': loss,
      'draw': draw,
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      spcId: map['spc_id'],
      win: map['win'],
      loss: map['loss'],
      draw: map['draw'],
    );
  }
}
