import 'package:flutter/material.dart';

class UniversalAnswerButtons extends StatelessWidget {
  final List<int> answerOptions;
  final Function(int) onAnswerSelected;
  final String level;

  const UniversalAnswerButtons({
    super.key,
    required this.answerOptions,
    required this.onAnswerSelected,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 2,
          runSpacing: 2,
          children: List.generate(
            answerOptions.length,
            (index) => GestureDetector(
              onTap: () => onAnswerSelected(answerOptions[index]),
              child: _buildAnswerButton(answerOptions[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(int answer) {
    String assetPath = 'assets/levels/mini_btn.png';

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.contain,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Text(
            '$answer',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
