import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixplay/game/math/levels_math_screen.dart';
import 'package:pixplay/game/math/levels_mode_screen.dart';
import 'package:pixplay/game/pairs/levels_pairs_screen.dart';

import 'quiz/level_quiz_screen.dart';
import 'settings/settings_widget.dart';

class MainScreenGame extends StatefulWidget {
  const MainScreenGame({super.key});

  @override
  State<MainScreenGame> createState() => _MainScreenGameState();
}

class _MainScreenGameState extends State<MainScreenGame> {
  bool isSettingsVisible = false;

  void _toggleSettings() {
    setState(() {
      isSettingsVisible = !isSettingsVisible;
    });
  }

  void _navigateToGame(String gameType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DifficultySelectionScreen(gameType: gameType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/bgChooseGame.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              right: MediaQuery.of(context).size.width * 0.05,
              child: GestureDetector(
                onTap: _toggleSettings,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/settings_icon.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.26,
              left: MediaQuery.of(context).size.width * 0.20,
              child: Container(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width * .6,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MathGameScreen()),
                        );
                      },
                      child: Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width * .5,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/buttons/examples_game_mode.png'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PairsLevelsScreen()),
                        );
                      },
                      child: Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width * .5,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/buttons/memory_game_mode.png'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuizLevelsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width * .5,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/buttons/quiz_game_mode.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isSettingsVisible)
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SettingsOverlay(
                  onClose: _toggleSettings,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
