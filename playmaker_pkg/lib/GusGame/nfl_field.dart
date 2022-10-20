import 'package:flame/components.dart';

import 'nfl_endzone.dart';
import 'nfl_image_cache.dart';

class NFLField extends SpriteComponent with HasGameRef {
  //final NFLEndZone _nflEndZone = NFLEndZone();

  late NFLEndZone _topEndZone;
  late NFLEndZone _bottomEndZone;
  //NFLEndZone _bottomEndZone = NFLEndZone();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = Sprite(NFLImages.images.fromCache('BigField.png'));
    size = gameRef.size;
    anchor = Anchor.center;
    position = gameRef.size / 2;

    _topEndZone = NFLEndZone(
      Vector2(gameRef.size.x / 2, 30),
      Vector2(gameRef.size.x, 60),
      false,
    );

    _bottomEndZone = NFLEndZone(
      Vector2(gameRef.size.x / 2, gameRef.size.y - 30),
      Vector2(gameRef.size.x, 60),
      true,
    );

    add(_topEndZone);
    add(_bottomEndZone);
  }
}
