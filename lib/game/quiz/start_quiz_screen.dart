import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pixplay/game/pairs/result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'quiz_model.dart';

class QuizLevelScreen extends StatefulWidget {
  final int level;

  const QuizLevelScreen({Key? key, required this.level}) : super(key: key);

  @override
  _QuizLevelScreenState createState() => _QuizLevelScreenState();
}

class _QuizLevelScreenState extends State<QuizLevelScreen> {
  static List<Question> _getQuestions() {
    return [
      Question(
        question:
            "What is the term for a loan that must be repaid with interest?",
        answers: ["Mortgage", "Investment", "Savings", "Income"],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "What is a stock?",
        answers: ["Ownership in a company", "A type of bond", "Cash", "A loan"],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "What does ROI stand for?",
        answers: [
          "Return on Investment",
          "Rate of Interest",
          "Return on Income",
          "Revenue of Investment"
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "Which of the following is considered an asset?",
        answers: ["House", "Debt", "Credit Card", "Loan"],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "What is the primary purpose of a budget?",
        answers: [
          "Plan spending",
          "Track income",
          "Invest money",
          "Pay off debt"
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "What does diversification mean in finance?",
        answers: [
          "Spreading investments",
          "Concentrating investments",
          "Borrowing money",
          "Saving money"
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "What is an emergency fund?",
        answers: [
          "Savings for emergencies",
          "Loan repayment fund",
          "Investment fund",
          "Retirement fund"
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "What is interest?",
        answers: [
          "Cost of borrowing money",
          "Profit from investments",
          "Savings account",
          "Expense"
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "What is a budget surplus?",
        answers: ["Excess money after expenses", "Debt", "Savings", "Loan"],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "What is a financial advisor?",
        answers: [
          "A professional who helps with finances",
          "A loan officer",
          "An accountant",
          "A banker"
        ],
        correctAnswerIndex: 0,
      ),
    ];
  }

  final List<Question> questions = _getQuestions();
  int currentQuestionIndex = 0;
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
  }

  void _checkAnswer(int selectedAnswerIndex) {
    if (selectedAnswerIndex ==
        questions[currentQuestionIndex].correctAnswerIndex) {
      correctAnswers++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('quiz_level_${widget.level}_completed',
        correctAnswers == questions.length);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultScreenMath(
          result: correctAnswers == questions.length ? true : false,
          errorsNum: questions.length - correctAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final shuffledAnswers = List.of(question.answers)..shuffle(Random());

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/bg/bgQuizGame.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .05,
            left: MediaQuery.of(context).size.width * .05,
            child: Container(
                width: MediaQuery.of(context).size.width * .9,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/backBtn.png')),
                          )),
                    ),
                    const Spacer(),
                    Text(
                      '${currentQuestionIndex + 1}/${questions.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 60,
                    ),
                  ],
                )),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .15,
            left: MediaQuery.of(context).size.width * .05,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width * .9,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/quiz_form.png'),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .7,
                    child: Text(
                      question.question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 10,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .25,
            left: MediaQuery.of(context).size.width * .05,
            child: Container(
              height: MediaQuery.of(context).size.height * .7,
              width: MediaQuery.of(context).size.width * .9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(shuffledAnswers.length, (index) {
                        return GestureDetector(
                          onTap: () => _checkAnswer(
                              shuffledAnswers.indexOf(question.answers[index])),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width * .3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                image: AssetImage('assets/quiz_answer.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * .6,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    shuffledAnswers[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
