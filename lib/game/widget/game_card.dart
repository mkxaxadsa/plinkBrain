import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pixplay/game/widget/card_model.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.card,
    this.size = 150,
    required this.onPressed,
  });

  final CardModel card;
  final double size;
  final void Function(CardModel) onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: card.done || card.visible
          ? null
          : () {
              onPressed(card);
            },
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: size,
        width: size,
        child: card.visible
            ? Stack(
                children: [
                  SvgPicture.asset('assets/card.svg'),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset('assets/cards/c${card.id}.png'),
                    ),
                  ),
                ],
              )
            : SvgPicture.asset('assets/hide.svg'),
      ),
    );
  }
}
