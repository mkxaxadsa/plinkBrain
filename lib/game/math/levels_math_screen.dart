import 'package:flutter/material.dart';
import 'package:pixplay/game/main_screen.dart';
import '../widget/choose_hard.dart';

class DifficultySelectionScreen extends StatelessWidget {
  final String gameType;

  const DifficultySelectionScreen({super.key, required this.gameType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bgLvl.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.05,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreenGame(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/homeBtn.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.15,
                  left: 0,
                  right: 0,
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: DifficultyGridView(
                        gameType: gameType,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
