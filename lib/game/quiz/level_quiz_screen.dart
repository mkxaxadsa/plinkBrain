// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:pixplay/game/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'start_quiz_screen.dart';

class QuizLevelsScreen extends StatefulWidget {
  const QuizLevelsScreen({Key? key}) : super(key: key);

  @override
  _QuizLevelsScreenState createState() => _QuizLevelsScreenState();
}

class _QuizLevelsScreenState extends State<QuizLevelsScreen> {
  late Future<List<bool>> _completedLevelsFuture;

  @override
  void initState() {
    super.initState();
    _completedLevelsFuture = loadCompletedLevels();
  }

  Future<List<bool>> loadCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    List<bool> completedLevels = List.filled(6, false);
    for (int i = 0; i < completedLevels.length; i++) {
      completedLevels[i] =
          prefs.getBool('quiz_level_${i + 1}_completed') ?? false;
    }
    completedLevels[0] = true;

    return completedLevels;
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
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
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
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: FutureBuilder<List<bool>>(
                    future: _completedLevelsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return QuizLevelsWidget(
                            completedLevels: snapshot.data!);
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizLevelsWidget extends StatelessWidget {
  final List<bool> completedLevels;

  const QuizLevelsWidget({Key? key, required this.completedLevels})
      : super(key: key);

  Future<void> updateLevelProgress(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('quiz_level_${level}_completed', true);
    if (level < 6) {
      await prefs.setBool('quiz_level_${level + 1}_completed', true);
    }
  }

  void _selectLevel(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizLevelScreen(
          level: index,
        ),
      ),
    ).then((isLevelCompleted) {
      if (isLevelCompleted == true) {
        updateLevelProgress(index).then((_) {
          if (context is StatefulElement) {
            context.state.setState(() {});
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: completedLevels.length,
      itemBuilder: (BuildContext context, index) {
        bool unlocked = index == 0 || completedLevels[index - 1];
        String imagePath;
        if (completedLevels[index]) {
          imagePath = 'assets/buttons/pairs/level_bg_icon.png';
        } else if (unlocked) {
          imagePath = 'assets/buttons/pairs/level_bg_icon.png';
        } else {
          imagePath = 'assets/buttons/pairs/level_bg_icon_locked.png';
        }

        return GestureDetector(
          onTap: unlocked ? () => _selectLevel(context, index + 1) : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                child: Stack(
                  children: [
                    Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      width: 120,
                      height: 120,
                    ),
                    if (unlocked)
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}', // Show the level number
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
