import 'package:flutter/cupertino.dart';

import 'nfl_game.dart';

class ScoreBoard extends StatefulWidget {
  const ScoreBoard({required this.game, super.key});

  final NFLGame game;

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  int _teamAScore = 0;
  int _teamBScore = 0;
  int _downs = 0;

  void setScore(int teamA, int teamB, int downs) {
    setState(() {
      _teamAScore = teamA;
      _teamBScore = teamB;
      _downs = downs;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.game.onSetScores = setScore;
  }

  @override
  Widget build(BuildContext context) {
    return Text('H $_teamAScore - $_teamBScore A | D: $_downs');
  }
}
