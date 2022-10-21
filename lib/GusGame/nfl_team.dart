import 'nfl_player.dart';

class NFLTeam {
  final _players = <NFLPlayer>[];

  late final Function onPlayComplete;
  bool playComplete = false;

  int score = 0;

  void resetPlay(double startingLine, double fieldWidth) {
    for (int i = 0; i < _players.length; i++) {
      _players[i].position.y = startingLine;
      _players[i].position.x = (fieldWidth / (_players.length + 1)) * (i + 1);
    }
  }

  void setTurn(bool isTurn) {
    for (var element in _players) {
      element.setTurn(isTurn);
    }
  }

  void playBall() {
    for (var element in _players) {
      element.isPlayReady = true;
    }
    playComplete = false;
  }

  void addPlayer(NFLPlayer player) {
    _players.add(player);
    player.onPlayComplete = checkPlayComplete;
  }

  void checkPlayComplete() {
    for (var element in _players) {
      if (element.isPlayReady) return;
    }
    playComplete = true;
    onPlayComplete();
    print('play complete');
  }
}
