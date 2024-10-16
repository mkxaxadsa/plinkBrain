import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pixplay/game/pairs/result_screen.dart';
import 'package:pixplay/game/widget/card_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PairsLevelsWidget extends StatefulWidget {
  final int level;

  const PairsLevelsWidget({Key? key, required this.level}) : super(key: key);

  @override
  _PairsLevelsWidgetState createState() => _PairsLevelsWidgetState();
}

class _PairsLevelsWidgetState extends State<PairsLevelsWidget> {
  List<CardModel> cards = [];
  int subLevel = 0;
  bool isChecking = false;
  CardModel? firstCard;
  Timer? timer;
  double timeLeft = 15.0;

  @override
  void initState() {
    super.initState();
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
      int id = i % 6;
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
            builder: (context) => const ResultScreen(result: false)),
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
      // Proceed to the next sub-level
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            subLevel++;
          });
          startSubLevel(); // Start the next sub-level
        }
      });
    } else {
      // When all sub-levels are completed, mark the level as done
      saveLevelCompletion();
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResultScreen(result: true),
          ),
        );
      });
    }
  }

  Future<void> saveLevelCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('level_${widget.level}_completed',
        true); // Save current level as completed
  }

  @override
  void dispose() {
    timer?.cancel();
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
                            width: (timeLeft / 15).clamp(0.0, 1.0) * 200,
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
              Expanded(
                child: Center(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: subLevel == 2 ? 3 : 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 130 / 190,
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

class GameCard extends StatelessWidget {
  final CardModel card;
  final void Function(CardModel) onPressed;

  const GameCard({
    Key? key,
    required this.card,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.done || card.visible ? null : () => onPressed(card),
      child: Container(
        width: 130,
        height: 190,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: card.visible
            ? Stack(
                children: [
                  Image.asset('assets/card_background.png', fit: BoxFit.cover),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset('assets/cards/c${card.id}.png'),
                    ),
                  ),
                ],
              )
            : Image.asset('assets/hide_card.png', fit: BoxFit.cover),
      ),
    );
  }
}
