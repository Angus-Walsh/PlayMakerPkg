library playmaker_pkg;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'GusGame/nfl_state_color.dart';
import 'GusGame/nfl_game.dart';

class NFLGameWidget extends StatelessWidget {
  NFLGameWidget({super.key});

  final game = NFLGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GameStateButton(game: game),
      body: GameWidget(
        game: game,
      ),
      //floatingActionButton: GameStateButton(game: game),
    );
  }
}
