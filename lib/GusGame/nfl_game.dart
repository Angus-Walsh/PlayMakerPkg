import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'nfl_image_cache.dart';
import 'nfl_matchController.dart';
import 'nfl_ball.dart';
import 'nfl_player.dart';
import 'nfl_field.dart';

class NFLGame extends FlameGame
    with HasDraggableComponents, HasCollisionDetection {
  Function(int, int, int)? onSetScores;
  Function(int)? onSetcolour;

  //final NFLEndZone _nflEndZone = NFLEndZone();
  final NFLPlayer _nflPlayer1 = NFLPlayer(true);
  final NFLPlayer _nflPlayer2 = NFLPlayer(true);
  final NFLPlayer _nflPlayer3 = NFLPlayer(true);
  final NFLPlayer _nflPlayer4 = NFLPlayer(false);
  final NFLPlayer _nflPlayer5 = NFLPlayer(false);
  final NFLPlayer _nflPlayer6 = NFLPlayer(false);
  final NFLField _nflField = NFLField();
  final NFLBall _nflBall = NFLBall();

  final NFLMatchController _matchController = NFLMatchController();

  void onNextPressed() {
    _matchController.nextState();
    print('NEXT!!');
  }

  @override
  Future<void> onLoad() async {
    //final NFLOpponent _nflOpponent = NFLOpponent(_nflPlayer);

    super.onLoad();

    await NFLImages.images.loadAll(
        ['Player.png', 'Opponent.png', 'BigField.png', 'Football.png']);

    await add(_nflField);
    //await add(_nflEndZone);
    await add(_nflPlayer1);
    await add(_nflPlayer2);
    await add(_nflPlayer3);
    await add(_nflPlayer4);
    await add(_nflPlayer5);
    await add(_nflPlayer6);
    await add(_nflBall);

    _matchController.onSetScores = onSetScores;
    _matchController.onSetColor = onSetcolour;

    _matchController.addPlayer(_nflPlayer1);
    _matchController.addPlayer(_nflPlayer2);
    _matchController.addPlayer(_nflPlayer3);
    _matchController.addPlayer(_nflPlayer4);
    _matchController.addPlayer(_nflPlayer5);
    _matchController.addPlayer(_nflPlayer6);

    _matchController.initPlay(_nflField.size.y / 2, _nflField.size.x, _nflBall);
  }
}
