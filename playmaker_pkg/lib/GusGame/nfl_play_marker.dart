import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class NFLPlayMarker extends CircleComponent {
  NFLPlayMarker(this.pos);

  final Vector2 pos;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //sprite = Sprite(Flame.images.fromCache('Marker.png'));
    position = pos;
    anchor = Anchor.center;
    paint = Paint()..color = const Color(0xFFFFFF00);
    size = Vector2(5, 5);
    //print('New marker: $pos');
  }
}
