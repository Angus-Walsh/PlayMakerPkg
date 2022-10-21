import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'nfl_game.dart';
import 'nfl_scoreboard_widget.dart';

class GameStateButton extends StatefulWidget implements PreferredSizeWidget {
  const GameStateButton({required this.game, super.key});

  final NFLGame game;

  @override
  State<GameStateButton> createState() => _GameStateButtonState();
  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _GameStateButtonState extends State<GameStateButton> {
  Color stateColor = Colors.lightBlue;

  void setColor(int state) {
    setState(() {
      switch (state) {
        case 0:
          stateColor = Colors.lightBlue;
          break;
        case 1:
          stateColor = Colors.red;
          break;
        case 2:
          stateColor = Colors.green;
          break;
        default:
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.game.onSetcolour = setColor;
  }

  @override
  Widget build(BuildContextcontext) {
    return AppBar(
      title: ScoreBoard(game: widget.game),
      backgroundColor: stateColor,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.play_circle),
          tooltip: 'Next',
          onPressed: () {
            widget.game.onNextPressed();
          },
        ),
      ],
    );
  }
}
