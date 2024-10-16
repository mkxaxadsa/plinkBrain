import 'package:flutter/material.dart';
import 'package:pixplay/game/pairs/result_screen.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import 'answers_buttons_widget.dart';

class PyramidLevelIndicator extends StatelessWidget {
  final List<String> levelStates;
  final String Function(String) getAssetName;

  const PyramidLevelIndicator({
    Key? key,
    required this.levelStates,
    required this.getAssetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double itemSize = maxWidth / 7;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int row = 0; row < 7; row++)
              Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int col = 0; col <= row; col++)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: itemSize * 0.1),
                        child: _buildLevelIndicator(row, col, itemSize),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLevelIndicator(int row, int col, double size) {
    int index = _getIndexFromRowCol(row, col);
    if (index >= levelStates.length) return SizedBox(width: size, height: size);

    String assetName = getAssetName(levelStates[index]);
    return Container(
      width: 40,
      height: 40,
      child: Image.asset(assetName, fit: BoxFit.contain),
    );
  }

  int _getIndexFromRowCol(int row, int col) {
    return (row * (row + 1) ~/ 2) + col;
  }
}

class StartGameScreen extends StatefulWidget {
  final int levelIndex;
  final String level;
  const StartGameScreen(
      {Key? key, required this.levelIndex, required this.level})
      : super(key: key);

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  List<String> levelStates = List.filled(28, 'empty');
  int firstNumber = 0;
  int secondNumber = 0;
  int correctAnswer = 0;
  List<int> answerOptions = [0, 0];
  int wrongAnswers = 0;
  int totalAnswered = 0;
  int coinCount = 10; // Количество монет
  final Random random = Random();
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeGame();
  }

  Future<void> _initializeGame() async {
    await loadProgress();
    await loadCoinCount();
    generateProblem();
  }

  Future<void> loadCoinCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      coinCount = prefs.getInt('coinCount') ?? 0;
    });
  }

  Future<void> saveCoinCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coinCount', coinCount);
  }

  void generateProblem() {
    switch (widget.level) {
      case 'addition':
        firstNumber = random.nextInt(50) + 1;
        secondNumber = random.nextInt(50) + 1;
        correctAnswer = firstNumber + secondNumber;
        break;
      case 'multiplication':
        firstNumber = random.nextInt(12) + 1;
        secondNumber = random.nextInt(12) + 1;
        correctAnswer = firstNumber * secondNumber;
        break;
      case 'division':
        secondNumber = random.nextInt(10) + 1;
        correctAnswer = random.nextInt(10) + 1;
        firstNumber = secondNumber * correctAnswer;
        break;
    }
    generateAnswerOptions();
  }

  void generateAnswerOptions() {
    Set<int> options = {correctAnswer};
    int numberOfOptions = widget.level == 'multiplication' ? 9 : 5;

    while (options.length < numberOfOptions) {
      int offset = random.nextInt(5) + 1;
      int option = correctAnswer + (random.nextBool() ? offset : -offset);
      if (option > 0) {
        options.add(option);
      }
    }

    answerOptions = options.toList()..shuffle();
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? completedLevelsMath =
        prefs.getStringList('completedLevelsMath');
    if (completedLevelsMath == null) {
      await prefs.setStringList('completedLevelsMath', []);
    }
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> completedLevelsMath =
        prefs.getStringList('completedLevelsMath') ?? [];
    String levelKey = '${widget.level}_${widget.levelIndex}';
    if (!completedLevelsMath.contains(levelKey)) {
      completedLevelsMath.add(levelKey);
      await prefs.setStringList('completedLevelsMath', completedLevelsMath);
    }
    await prefs.setInt('${levelKey}_wrongAnswers', wrongAnswers);
  }

  String getOperatorSymbol() {
    switch (widget.level) {
      case 'addition':
        return '+';
      case 'multiplication':
        return '×';
      case 'division':
        return '÷';
      default:
        return '+';
    }
  }

  String getAssetPrefix() => 'assets/levels/${widget.level}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bgLvl.png'),
                  fit: BoxFit.fill,
                ),
              ),
            );
          }

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bgLvl.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(children: [
                  const SizedBox(height: 90),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/backBtn.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/coin.png'),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$coinCount',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.34,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        PyramidLevelIndicator(
                          levelStates: levelStates,
                          getAssetName: (state) {
                            if (state == 'filled') {
                              return '${getAssetPrefix()}_green.png';
                            } else if (state == 'failed') {
                              return '${getAssetPrefix()}_failed.png';
                            } else {
                              return '${getAssetPrefix()}_empty.png';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: widget.level == 'multiplication'
                        ? UniversalAnswerButtons(
                            answerOptions: answerOptions,
                            onAnswerSelected: (answer) =>
                                checkAnswer(answer, setState),
                            level: widget.level,
                          )
                        : widget.level == 'division'
                            ? UniversalAnswerButtons(
                                answerOptions: answerOptions,
                                onAnswerSelected: (answer) =>
                                    checkAnswer(answer, setState),
                                level: widget.level,
                              )
                            : UniversalAnswerButtons(
                                answerOptions: answerOptions,
                                onAnswerSelected: (answer) =>
                                    checkAnswer(answer, setState),
                                level: widget.level,
                              ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/levels/bgMath.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$firstNumber ${getOperatorSymbol()} $secondNumber = ?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void checkAnswer(int selectedAnswer, StateSetter setStateCallback) {
    setStateCallback(() {
      totalAnswered++;
      if (selectedAnswer == correctAnswer) {
        setState(() {
          coinCount += 1;
        });
        int emptyIndex = levelStates.indexOf('empty');
        if (emptyIndex != -1) {
          levelStates[emptyIndex] = 'filled';
        }
      } else {
        wrongAnswers++;
        int emptyIndex = levelStates.indexOf('empty');
        if (emptyIndex != -1) {
          levelStates[emptyIndex] = 'failed';
        }
      }
    });

    if (totalAnswered == 28) {
      _finishLevel();
    } else {
      generateProblem();
    }
  }

  void _finishLevel() async {
    await saveProgress();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => ResultScreenMath(
          result: wrongAnswers == 0,
          errorsNum: wrongAnswers,
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
