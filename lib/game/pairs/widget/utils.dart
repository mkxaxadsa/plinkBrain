import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:pixplay/game/widget/card_model.dart';

void logger(Object message) {
  try {
    developer.log(message.toString());
  } catch (e) {
    debugPrint(e.toString());
  }
}

String getGameBg(int level) {
  if (level == 2) return 'assets/bg/bg1.jpg';
  if (level == 3) return 'assets/bg/bg2.jpg';
  if (level == 4) return 'assets/bg/bg3.jpg';
  if (level == 5) return 'assets/bg/bg6.png';
  if (level == 1) return 'assets/bg/bg5.png';
  if (level == 6) return 'assets/bg/bg8.png';
  if (level == 7) return 'assets/bg/bg4.jpg';
  if (level == 8) return 'assets/bg/bg7.png';
  return 'assets/bg/bg5.png';
}

double getCardSize(int level) {
  if (level == 1) return 150;
  if (level == 2) return 150;
  if (level == 3) return 150;
  if (level == 4) return 150;
  if (level == 5) return 120;
  if (level == 6) return 120;
  if (level == 7) return 100;
  if (level == 8) return 100;
  return 100;
}

List<CardModel> getGameCards(int level) {
  if (level == 1) {
    return [
      CardModel(id: 1, visible: true, done: false),
      CardModel(id: 1, visible: true, done: false),
      CardModel(id: 2, visible: true, done: false),
      CardModel(id: 2, visible: true, done: false),
    ];
  }
  if (level == 2) {
    return [
      CardModel(id: 3, visible: true, done: false),
      CardModel(id: 3, visible: true, done: false),
      CardModel(id: 4, visible: true, done: false),
      CardModel(id: 4, visible: true, done: false),
      CardModel(id: 5, visible: true, done: false),
      CardModel(id: 5, visible: true, done: false),
    ];
  }
  if (level == 3) {
    return [
      CardModel(id: 6, visible: true, done: false),
      CardModel(id: 6, visible: true, done: false),
      CardModel(id: 7, visible: true, done: false),
      CardModel(id: 7, visible: true, done: false),
      CardModel(id: 8, visible: true, done: false),
      CardModel(id: 8, visible: true, done: false),
    ];
  }
  if (level == 4) {
    return [
      CardModel(id: 9, visible: true, done: false),
      CardModel(id: 9, visible: true, done: false),
      CardModel(id: 10, visible: true, done: false),
      CardModel(id: 10, visible: true, done: false),
      CardModel(id: 11, visible: true, done: false),
      CardModel(id: 11, visible: true, done: false),
    ];
  }
  if (level == 5) {
    return [
      CardModel(id: 12, visible: true, done: false),
      CardModel(id: 12, visible: true, done: false),
      CardModel(id: 13, visible: true, done: false),
      CardModel(id: 13, visible: true, done: false),
      CardModel(id: 14, visible: true, done: false),
      CardModel(id: 14, visible: true, done: false),
      CardModel(id: 15, visible: true, done: false),
      CardModel(id: 15, visible: true, done: false),
    ];
  }
  if (level == 6) {
    return [
      CardModel(id: 16, visible: true, done: false),
      CardModel(id: 16, visible: true, done: false),
      CardModel(id: 17, visible: true, done: false),
      CardModel(id: 17, visible: true, done: false),
      CardModel(id: 18, visible: true, done: false),
      CardModel(id: 18, visible: true, done: false),
      CardModel(id: 19, visible: true, done: false),
      CardModel(id: 19, visible: true, done: false),
    ];
  }
  if (level == 7) {
    return [
      CardModel(id: 20, visible: true, done: false),
      CardModel(id: 20, visible: true, done: false),
      CardModel(id: 21, visible: true, done: false),
      CardModel(id: 21, visible: true, done: false),
      CardModel(id: 22, visible: true, done: false),
      CardModel(id: 22, visible: true, done: false),
      CardModel(id: 23, visible: true, done: false),
      CardModel(id: 23, visible: true, done: false),
      CardModel(id: 24, visible: true, done: false),
      CardModel(id: 24, visible: true, done: false),
      CardModel(id: 25, visible: true, done: false),
      CardModel(id: 25, visible: true, done: false),
    ];
  }
  if (level == 8) {
    return [
      CardModel(id: 26, visible: true, done: false),
      CardModel(id: 26, visible: true, done: false),
      CardModel(id: 27, visible: true, done: false),
      CardModel(id: 27, visible: true, done: false),
      CardModel(id: 28, visible: true, done: false),
      CardModel(id: 28, visible: true, done: false),
      CardModel(id: 29, visible: true, done: false),
      CardModel(id: 29, visible: true, done: false),
      CardModel(id: 30, visible: true, done: false),
      CardModel(id: 30, visible: true, done: false),
      CardModel(id: 31, visible: true, done: false),
      CardModel(id: 31, visible: true, done: false),
    ];
  }
  return [
    CardModel(id: 1, visible: true, done: false),
    CardModel(id: 1, visible: true, done: false),
    CardModel(id: 2, visible: true, done: false),
    CardModel(id: 2, visible: true, done: false),
  ];
}
