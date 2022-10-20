import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class NFLEndZone extends RectangleComponent with HasGameRef {
  NFLEndZone(this.basePos, this.baseSize, this.isTeamA);

  final Vector2 basePos;
  final Vector2 baseSize;
  final bool isTeamA;

  final hitBox = RectangleHitbox();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    position = basePos;
    size = baseSize;
    paint = Paint()..color = Color.fromARGB(0, 255, 0, 234);
    //hitBox.collisionType = CollisionType.passive;
    add(hitBox);
    print('Load anchor: ${anchor}, size: ${size}');
  }
}
