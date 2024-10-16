import 'package:flutter/material.dart';
import 'package:pixplay/game/main_screen.dart';

import 'levels_pairs_screen.dart';

class ResultScreen extends StatefulWidget {
  final bool result;
  const ResultScreen({super.key, required this.result});
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/bgResultPairs.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Align(
                alignment: AlignmentDirectional.center,
                child: Image.asset(
                  widget.result
                      ? 'assets/images/result_pairs_text_win.png'
                      : 'assets/images/result_pairs_text_fail.png',
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Container(
                height: height * .6,
                width: width * .7,
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Image.asset(
                        'assets/images/result_pairs_pers.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Container(
                  height: height * .08,
                  width: width * .5,
                  child: Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreenGame(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Image.asset('assets/images/homeBtn.png')),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PairsLevelsScreen()),
                            );
                          },
                          child: Image.asset('assets/images/retryBtn.png')),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ResultScreenMath extends StatefulWidget {
  final bool result;
  final int errorsNum;
  const ResultScreenMath(
      {super.key, required this.result, required this.errorsNum});
  @override
  State<ResultScreenMath> createState() => _ResultScreenMathState();
}

class _ResultScreenMathState extends State<ResultScreenMath> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/bgResultPairs.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Align(
                alignment: AlignmentDirectional.center,
                child: Container(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width * .8,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/result_math_container_text.png',
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Well Done!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Errors: ${widget.errorsNum}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Container(
                height: height * .6,
                width: width * .7,
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Image.asset(
                        'assets/images/result_pairs_pers.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Container(
                  height: height * .08,
                  width: width * .5,
                  child: Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreenGame(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Image.asset('assets/images/homeBtn.png')),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
