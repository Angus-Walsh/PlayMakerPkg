import 'nfl_ball.dart';
import 'nfl_player.dart';
import 'nfl_team.dart';

class NFLMatchController {
  final _teamA = NFLTeam();
  final _teamB = NFLTeam();

  bool _allPlaysComplete = false;
  bool _touchDownScored = false;
  bool _teamAonOffence = true;

  int _downs = 0;
  final int _maxDowns = 3;

  Function(int, int, int)? onSetScores;
  Function(int)? onSetColor;

  late final NFLBall _ball;

  MatchState gameState = MatchState.offensivePlan;

  late final double _startingLine;
  late final double _fieldWidth;

  void initPlay(double startingLine, double fieldWidth, NFLBall ball) {
    _startingLine = startingLine;
    _fieldWidth = fieldWidth;
    _ball = ball;
    resetPlay();
    setTeamTurn();
    _teamA.onPlayComplete = allPlaysComplete;
    _teamB.onPlayComplete = allPlaysComplete;
  }

  void resetPlay() {
    double teamAOffset = _teamAonOffence ? 0 : 100;
    double teamBOffset = _teamAonOffence ? -100 : 0;

    _teamA.resetPlay(_startingLine + teamAOffset, _fieldWidth);
    _teamB.resetPlay(_startingLine + teamBOffset, _fieldWidth);
    resetBall();
  }

  void resetPlayToBall() {
    double teamAOffset = _teamAonOffence ? 0 : 100;
    double teamBOffset = _teamAonOffence ? -100 : 0;

    double setBack = 150;

    if (_ball.position.y > (_startingLine * 2) - setBack) {
      _ball.position.y = (_startingLine * 2) - setBack;
    } else if (_ball.position.y < setBack) {
      _ball.position.y = setBack;
    }

    _teamA.resetPlay(_ball.position.y + teamAOffset, _fieldWidth);
    _teamB.resetPlay(_ball.position.y + teamBOffset, _fieldWidth);
    setBallToCentre();
  }

  void nextState() {
    switch (gameState) {
      case MatchState.offensivePlan:
        gameState = MatchState.defensivePlan;
        setTeamTurn();
        break;
      case MatchState.defensivePlan:
        gameState = MatchState.playGame;
        deactivateTeams();
        playBall();
        onSetColor!(2);
        break;
      case MatchState.playGame:
        if (!_allPlaysComplete) return;
        gameState = MatchState.offensivePlan;
        setTeamTurn();

        if (_touchDownScored) {
          resetPlay();
        } else {
          resetPlayToBall();
        }

        _allPlaysComplete = false;
        _touchDownScored = false;
        break;
      default:
    }
  }

  void allPlaysComplete() {
    if (_teamA.playComplete && _teamB.playComplete) {
      _allPlaysComplete = true;

      if (!_touchDownScored) {
        teamDown();
      }
    }
  }

  void teamDown() {
    _downs++;
    _reportScore();
    if (_downs >= _maxDowns) {
      _teamAonOffence = !_teamAonOffence;
      _ball.currentPlayer = null;
      _ball.deactivate();
      _downs = 0;
      _reportScore();
    }
    print('Score: ${_teamA.score} - ${_teamB.score} downs: $_downs');
  }

  void touchDownScored(NFLPlayer player) {
    _touchDownScored = true;
    _teamAonOffence = !_teamAonOffence;
    if (player.isTeamA) {
      _teamA.score++;
    } else {
      _teamB.score++;
    }
    _downs = 0;
    _reportScore();
    print('Score: ${_teamA.score} - ${_teamB.score} downs: $_downs');
  }

  void _reportScore() {
    if (onSetScores != null) onSetScores!(_teamA.score, _teamB.score, _downs);
  }

  void setTeamTurn() {
    switch (gameState) {
      case MatchState.offensivePlan:
        _teamA.setTurn(_teamAonOffence);
        _teamB.setTurn(!_teamAonOffence);
        int turnState = _teamAonOffence ? 0 : 1;
        onSetColor!(turnState);
        break;
      case MatchState.defensivePlan:
        _teamA.setTurn(!_teamAonOffence);
        _teamB.setTurn(_teamAonOffence);
        int turnState = _teamAonOffence ? 1 : 0;
        onSetColor!(turnState);
        break;
      default:
    }
  }

  void playBall() {
    _teamA.playBall();
    _teamB.playBall();
    _ball.activate();
  }

  void setBallToCentre() {
    _ball.position.x = _fieldWidth / 2;
    _ball.deactivate();
  }

  void resetBall() {
    _ball.position.x = _fieldWidth / 2;
    _ball.position.y = _startingLine;
    _ball.deactivate();
  }

  void deactivateTeams() {
    _teamA.setTurn(false);
    _teamB.setTurn(false);
  }

  void addPlayer(NFLPlayer player) {
    if (player.isTeamA) {
      _teamA.addPlayer(player);
    } else {
      _teamB.addPlayer(player);
    }
    player.onTouchDownScored = touchDownScored;
  }
}

enum MatchState { offensivePlan, defensivePlan, playGame }
