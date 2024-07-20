import 'package:flutter/material.dart';
import 'package:mindflasher/models/flashcard.dart';
import 'package:mindflasher/providers/flashcard_provider.dart';
import 'package:provider/provider.dart';
import 'swipeable_card.dart';
import 'central_top_card.dart';

class FlashcardListScreen extends StatefulWidget {
  @override
  _FlashcardListScreenState createState() => _FlashcardListScreenState();
}

class _FlashcardListScreenState extends State<FlashcardListScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _removeItem(BuildContext context, FlashcardProvider provider, int index) {
    final flashcard = provider.flashcards[index];

    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildRemovedItem(flashcard, animation),
      duration: const Duration(milliseconds: 150),
    );

    provider.removeFlashcard(index);

    Future.delayed(const Duration(milliseconds: 300), () {
      _listKey.currentState?.insertItem(provider.flashcards.length, duration: const Duration(milliseconds: 300));
      provider.addFlashcard(flashcard);
    });
  }

  Widget _buildRemovedItem(Flashcard flashcard, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: CentralTopCard(
          flashcard: flashcard,
          onRemove: () {
            // Действие по удалению
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard List'),
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, provider, child) {
          return AnimatedList(
            key: _listKey,
            initialItemCount: provider.flashcards.length,
            itemBuilder: (context, index, animation) {
              if (index >= provider.flashcards.length) return SizedBox();
              final flashcard = provider.flashcards[index];
              return _buildItem(context, flashcard, index, animation);
            },
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, Flashcard flashcard, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: SwipeableCard(
        flashcard: flashcard,
        onRemove: () => _removeItem(context, Provider.of<FlashcardProvider>(context, listen: false), index),
      ),
    );
  }
}
