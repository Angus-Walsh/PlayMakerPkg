import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'nfl_image_cache.dart';
import 'nfl_player.dart';

import 'nfl_endzone.dart';

class NFLBall extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final hitBox = CircleHitbox();

  NFLPlayer? currentPlayer;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = Sprite(NFLImages.images.fromCache('Football.png'));
    anchor = Anchor.center;
    size = Vector2(20, 11);
    position = gameRef.size / 2;
    hitBox.collisionType = CollisionType.inactive;
    add(hitBox);
  }

  @override
  void update(double dt) {
    if (currentPlayer != null) {
      position = currentPlayer!.position;
    }
  }

  void activate() {
    hitBox.collisionType = CollisionType.active;
  }

  void deactivate() {
    hitBox.collisionType = CollisionType.inactive;
    currentPlayer = null;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    //super.onCollision(intersectionPoints, other);

    if (other is NFLEndZone) {
      //print('TOUCH DOWN!!!!');
      if (currentPlayer == null || currentPlayer!.isTeamA == other.isTeamA) {
        return;
      }

      currentPlayer!.onTouchDownScored(currentPlayer!);
      //currentPlayer = null;
      //deactivate();
    } else if (other is NFLPlayer) {
      //print('HIT PLAYER');
      currentPlayer = other;
    }
  }
}
