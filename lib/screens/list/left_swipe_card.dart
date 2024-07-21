import 'package:flutter/material.dart';
import 'package:mindflasher/models/flashcard.dart';
import 'package:mindflasher/providers/flashcard_provider.dart';
import 'package:provider/provider.dart';

class LeftSwipeCard extends StatelessWidget {
  final Flashcard flashcard;

  final double stopThreshold;

  const LeftSwipeCard({
    Key? key,
    required this.flashcard,
    required this.stopThreshold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: FractionallySizedBox(
        widthFactor: stopThreshold,
        alignment: Alignment.centerLeft,
        child: Card(
          surfaceTintColor: Colors.blueAccent.withOpacity(0.05),
          child: Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<FlashcardProvider>(context, listen: false).updateCardWeight(flashcard.id, 0);
                  },
                  child: Text('Удалить', style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
