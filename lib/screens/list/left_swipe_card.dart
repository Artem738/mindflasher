import 'package:flutter/material.dart';
import 'package:mindflasher/models/flashcard.dart';
import 'package:mindflasher/providers/flashcard_provider.dart';
import 'package:mindflasher/tech_data/weight_delays_enum.dart';
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
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: stopThreshold,
        child: Card(
          surfaceTintColor: Colors.blueAccent.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("ID: ${flashcard.id} "),
                    Text("Weight: ${flashcard.weight} "),
                  ],
                ),

                ElevatedButton(
                  onPressed: () {
                    Provider.of<FlashcardProvider>(context, listen: false).updateCardWeight(flashcard.id, WeightDelaysEnum.noDelay);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.zero,
                  ),
                  child: Center(
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
