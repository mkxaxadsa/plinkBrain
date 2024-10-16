import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pixplay/game/pairs/result_screen.dart';
import 'package:pixplay/game/widget/card_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelScreen extends StatefulWidget {
  final int level;

  const LevelScreen({Key? key, required this.level}) : super(key: key);

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen>
    with SingleTickerProviderStateMixin {
  List<CardModel> cards = [];
  int subLevel = 0;
  bool isChecking = false;
  CardModel? firstCard;
  Timer? timer;
  double timeLeft = 15.0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    startSubLevel();
  }

  void startSubLevel() {
    resetTimer();
    setState(() {
      cards = getGameCards(getCardCount());
      cards.shuffle();
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          for (var card in cards) {
            card.visible = false;
          }
        });
      }
    });
  }

  int getCardCount() {
    switch (subLevel) {
      case 0:
        return 4; // 2x2
      case 1:
        return 6; // 2x3
      case 2:
        return 12; // 3x4
      default:
        return 4;
    }
  }

  List<CardModel> getGameCards(int count) {
    List<CardModel> result = [];
    for (int i = 0; i < count ~/ 2; i++) {
      int id = i % 6; // Используем карточки от c0.png до c5.png
      result.add(CardModel(id: id, visible: true, done: false));
      result.add(CardModel(id: id, visible: true, done: false));
    }
    return result;
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      timeLeft = 15.0;
    });
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          timeLeft = (timeLeft - 0.1).clamp(0.0, 15.0);
          if (timeLeft <= 0) {
            timer.cancel();
            onTimeUp();
          }
        });
      }
    });
  }

  void onTimeUp() {
    timer?.cancel();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const ResultScreen(
                  result: false,
                )),
      );
    }
  }

  void onCard(CardModel value) {
    if (value.visible || value.done || isChecking) return;
    setState(() {
      value.visible = true;
    });

    if (firstCard == null) {
      firstCard = value;
    } else {
      if (firstCard!.id == value.id) {
        setState(() {
          value.done = true;
          firstCard!.done = true;
        });
        firstCard = null;
        if (checkWin()) {
          onWin();
        }
      } else {
        isChecking = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              value.visible = false;
              firstCard!.visible = false;
              isChecking = false;
              firstCard = null;
            });
          }
        });
      }
    }
  }

  bool checkWin() {
    return cards.every((card) => card.done);
  }

  void onWin() {
    timer?.cancel();
    if (subLevel < 2) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            subLevel++;
          });
          startSubLevel();
        }
      });
    } else {
      saveLevelCompletion();
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const ResultScreen(result: true)),
        );
      });
    }
  }

  Future<void> saveLevelCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('level_${widget.level}_completed', true);
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/bg/bgChooseGame.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Column(
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: Image.asset('assets/images/backBtn.png'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 200,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: (timeLeft / 15) * 200,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.lightBlueAccent],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(30),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: subLevel == 2 ? 3 : 2, // Меньше карточек
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 30,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      return GameCard(
                        card: cards[index],
                        onPressed: onCard,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatefulWidget {
  final CardModel card;
  final void Function(CardModel) onPressed;

  const GameCard({
    Key? key,
    required this.card,
    required this.onPressed,
  }) : super(key: key);

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _flipAnimation = Tween(begin: 0.0, end: 2.0).animate(_controller);
  }

  void flipCard() {
    if (widget.card.visible) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        flipCard();
        widget.onPressed(widget.card);
      },
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.rotationY(_flipAnimation.value * 3.14159),
            alignment: Alignment.center,
            child: Container(
              height: 130,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: widget.card.visible
                  ? Container(
                      height: 130,
                      width: 90,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/card_background.png'),
                        ),
                      ),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/cards/c${widget.card.id}.png'),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 120,
                      width: 80,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/hide_card.png'),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
