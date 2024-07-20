import 'package:flutter/material.dart';
import 'package:mindflasher/models/flashcard.dart';

class LeftSwipeCard extends StatelessWidget {
  final Flashcard flashcard;
  final VoidCallback onRemove;
  final double stopThreshold;

  const LeftSwipeCard({Key? key, required this.flashcard, required this.onRemove, required this.stopThreshold}) : super(key: key);

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
                  onPressed: onRemove,
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
