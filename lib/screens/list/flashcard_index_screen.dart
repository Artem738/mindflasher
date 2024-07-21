import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/flashcard_provider.dart';
import '../../models/flashcard.dart';
import 'swipeable_card.dart';

class FlashcardIndexScreen extends StatelessWidget {
  Widget _buildCardItem(BuildContext context, Flashcard card, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: SwipeableCard(
        flashcard: card,
        // onRemove: () {
        //  // context.read<FlashcardProvider>().updateCardWeight(card.id, 1);
        // },
        // onSwipe: (increment) {
        //  // context.read<FlashcardProvider>().updateCardWeight(card.id, increment);
        // },
        // onIncrease: (increment) {
        //   context.read<FlashcardProvider>().updateCardWeight(card.id, increment);
        // },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, flashcardProvider, child) {
          return AnimatedList(
            key: flashcardProvider.listKey,
            initialItemCount: flashcardProvider.flashcards.length,
            itemBuilder: (context, index, animation) {
              final flashcard = flashcardProvider.flashcards[index];
              return _buildCardItem(context, flashcard, animation);
            },
          );
        },
      ),
    );
  }
}
