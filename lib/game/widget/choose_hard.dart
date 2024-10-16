import 'package:flutter/material.dart';
import 'package:pixplay/game/math/main_math.dart';

import 'level_text.dart';

class DifficultyGridView extends StatefulWidget {
  final String gameType;

  const DifficultyGridView({super.key, required this.gameType});

  @override
  State<DifficultyGridView> createState() => _DifficultyGridViewState();
}

class _DifficultyGridViewState extends State<DifficultyGridView> {
  final List<bool> completedLevelsMath = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  void _selectDifficulty(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartGameScreen(
          levelIndex: index,
          level: widget.gameType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: completedLevelsMath.length,
        itemBuilder: (BuildContext context, index) {
          String imagePath = completedLevelsMath[index]
              ? 'assets/levels/${widget.gameType}_filled.png'
              : 'assets/levels/${widget.gameType}_empty.png';

          return LevelGridItem(
            imagePath: imagePath,
            levelIndex: index + 1,
            gameType: widget.gameType,
            isCompleted: completedLevelsMath[index],
            onTap: () => _selectDifficulty(context, index + 1),
          );
        },
      ),
    );
  }
}
