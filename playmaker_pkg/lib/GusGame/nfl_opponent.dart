import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'nfl_player.dart';

class NFLOpponent extends SpriteComponent with HasGameRef {
  NFLOpponent(this._nflPlayer);

  NFLPlayer _nflPlayer;

  final _speed = 100.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = Sprite(Flame.images.fromCache('Opponent.png'));
    anchor = Anchor.center;
    size = Vector2(40, 30);
    position.x = gameRef.size.x / 2;
    position.y = (gameRef.size.y / 2) - 200;
  }

  @override
  void update(double dt) {
    if (!_nflPlayer.isPlayReady) return;

    var targ = _findLeadingPosition(
        _nflPlayer.position, _nflPlayer.moveDirection, 200);

    var direction = targ - position;
    direction = direction.normalized();
    position += direction * _speed * dt;
  }

  Vector2 _findLeadingPosition(
      Vector2 target, Vector2 direction, double distanceAhead) {
    var distance = target.distanceTo(position);

    var leadingPosition = target + (direction * distance);
    //print(target.distanceTo(position));
    return leadingPosition;
  }
}
