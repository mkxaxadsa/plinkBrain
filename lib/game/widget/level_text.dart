import 'package:flutter/material.dart';

class LevelText extends StatelessWidget {
  final int levelIndex;
  final String gameType;

  const LevelText({
    Key? key,
    required this.levelIndex,
    required this.gameType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text;
    TextStyle textStyle;

    switch (gameType) {
      case 'multiplication':
        text = 'x';
        textStyle = const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        );
        break;
      case 'division':
        text = '÷';
        textStyle = const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        );

        break;
      case 'addition':
        text = '+';
        textStyle = const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        );

        break;
      default:
        text = '';
        textStyle = const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        );
        break;
    }

    return Container(
      width: 50,
      height: 50,
      child: Center(
        child: Text(
          '$text$levelIndex',
          style: textStyle,
        ),
      ),
    );
  }
}

class LevelGridItem extends StatelessWidget {
  final String imagePath;
  final int levelIndex;
  final String gameType;
  final bool isCompleted;
  final VoidCallback onTap;

  const LevelGridItem({
    Key? key,
    required this.imagePath,
    required this.levelIndex,
    required this.gameType,
    required this.isCompleted,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 170,
            width: 170,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.contain,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: gameType == 'division' ? 35.0 : 20.0,
                right: gameType == 'division' ? 0.0 : 20.0,
              ),
              child: Center(
                child: LevelText(
                  levelIndex: levelIndex,
                  gameType: gameType,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
