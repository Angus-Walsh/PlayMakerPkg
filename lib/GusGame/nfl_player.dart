import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import 'nfl_image_cache.dart';
import 'nfl_play_marker.dart';

class NFLPlayer extends SpriteComponent
    with HasGameRef, DragCallbacks, CollisionCallbacks {
  NFLPlayer(this.isTeamA) : super(size: Vector2(40, 30));

  late final Function onPlayComplete;
  late final Function(NFLPlayer) onTouchDownScored;

  final _playMarkers = List<NFLPlayMarker>.empty(growable: true);
  final double _speed = 100.0;

  final bool isTeamA;

  //NFLBall? _ball;

  bool isPlayReady = false;
  bool isTeamsTurn = false;

  Vector2 moveDirection = Vector2.zero();

  Vector2 _canvasOffset = Vector2.zero();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    anchor = Anchor.center;
    position = gameRef.size / 2;
    size = Vector2(40, 30);

    if (isTeamA) {
      sprite = Sprite(NFLImages.images.fromCache('Player.png'));
    } else {
      sprite = Sprite(NFLImages.images.fromCache('Opponent.png'));
    }

    var hitBox = CircleHitbox();
    hitBox.isSolid = false;
    add(hitBox);
  }

  @override
  void update(double dt) {
    if (!isPlayReady) return;
    _followMarkers(dt);

    //_ball?.position = position;
  }

  ///////// Collision callbacks /////////
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    //super.onCollision(intersectionPoints, other);

    if (other is NFLPlayer) {
      clearMarkers();
    }
    // else if (other is NFLBall) {
    //   other.hitBox.collisionType = CollisionType.inactive;
    //   //_ball = other;
    // } else if (other is NFLEndZone) {
    //   // if (_ball == null || other.isTeamA == isTeamA) return;
    //   // onTouchDownScored(this);
    //   // print('TOUCH DOWN!!!!');
    // }
  }

  ///////// Drag callbacks /////////
  @override
  void onDragStart(DragStartEvent event) {
    if (!isTeamsTurn) return;

    clearMarkers();
    _canvasOffset = event.devicePosition - position;
    _addMarker(position);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isTeamsTurn) return;

    _addMarker(event.devicePosition - _canvasOffset);
  }

  ///////// Public functions /////////

  void setTurn(bool isTurn) {
    isTeamsTurn = isTurn;
    if (isTurn) {
      _showMarkers();
    } else {
      _hideMarkers();
    }
  }

  ///////// Private functions /////////

  void clearMarkers() {
    for (var element in _playMarkers) {
      gameRef.remove(element);
    }
    _playMarkers.clear();
  }

  void _hideMarkers() {
    for (var element in _playMarkers) {
      element.setAlpha(0);
    }
  }

  void _showMarkers() {
    for (var element in _playMarkers) {
      element.setAlpha(0);
    }
  }

  void _addMarker(Vector2 pos) {
    if (_playMarkers.isNotEmpty && pos.distanceTo(_playMarkers.last.pos) < 10) {
      return;
    }

    NFLPlayMarker playMarker = NFLPlayMarker(pos);
    _playMarkers.add(playMarker);
    gameRef.add(playMarker);
  }

  void _followMarkers(double dt) {
    if (_playMarkers.isEmpty) {
      isPlayReady = false;
      onPlayComplete();
      return;
    }

    moveDirection = (_playMarkers.first.pos - position).normalized();
    position += moveDirection * dt * _speed;

    if (position.distanceToSquared(_playMarkers.first.pos) < 6) {
      gameRef.remove(_playMarkers.first);
      _playMarkers.removeAt(0);
    }
  }
}
