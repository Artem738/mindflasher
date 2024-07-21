import 'package:flutter/material.dart';
import 'package:mindflasher/models/deck.dart';
import 'package:provider/provider.dart';
import '../../providers/flashcard_provider.dart';
import '../../models/flashcard.dart';
import 'swipeable_card.dart';

class FlashcardIndexScreen extends StatelessWidget {
  final Deck deck;

  FlashcardIndexScreen({required this.deck});

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
        title: Text(deck.name),
      ),
      body: FutureBuilder(
        future: Provider.of<FlashcardProvider>(context, listen: false).fetchAndPopulateFlashcards(deck.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            return Consumer<FlashcardProvider>(
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
            );
          }
        },
      ),
    );
  }
}
