import 'package:flutter/material.dart';
import 'package:mindflasher/models/flashcard.dart';
import 'package:mindflasher/providers/flashcard_provider.dart';
import 'package:provider/provider.dart';

class RightAnswerCard extends StatelessWidget {
  final Flashcard flashcard;
  final double stopThreshold;

  const RightAnswerCard({
    Key? key,
    required this.flashcard,
    required this.stopThreshold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: FractionallySizedBox(
        widthFactor: stopThreshold,
        alignment: Alignment.centerRight,
        child: Card(
          surfaceTintColor: Colors.orangeAccent.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Левая колонка с кнопкой
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<FlashcardProvider>(context, listen: false).updateCardWeight(flashcard.id, 1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.zero,
                        ),
                        child: Center(
                          child: Icon(Icons.warning, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                // Текст
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        flashcard.answer,
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
                // Правая колонка с кнопкой
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<FlashcardProvider>(context, listen: false).updateCardWeight(flashcard.id, 10);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          padding: EdgeInsets.zero,
                        ),
                        child: Center(
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
