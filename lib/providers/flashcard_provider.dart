import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class FlashcardProvider with ChangeNotifier {
  final List<Flashcard> _flashcards = [];
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  List<Flashcard> get flashcards => _flashcards;

  void populateFlashcards(int count) {
    for (int i = 0; i < count; i++) {
      _flashcards.add(Flashcard(
        id: i.toString(),
        question: 'Question $i',
        answer: 'Answer $i',
      ));
    }
    notifyListeners();
  }

  void updateCardWeight(String id, int increment) {
    final index = _flashcards.indexWhere((card) => card.id == id);
    if (index != -1) {
      final flashcard = _flashcards[index];
      final updatedCard = flashcard.copyWith(weight: flashcard.weight + increment);

      listKey.currentState?.removeItem(
        index,
            (context, animation) => _buildRemovedCardItem(flashcard, animation),
        duration: const Duration(milliseconds: 300),
      );

      _flashcards.removeAt(index);
      Future.delayed(const Duration(milliseconds: 300), () {
        _flashcards.add(updatedCard);
        _sortFlashcardsByWeight();
        final newIndex = _flashcards.indexOf(updatedCard);
        listKey.currentState?.insertItem(
          newIndex,
          duration: const Duration(milliseconds: 300),
        );
        notifyListeners();
      });
    }
  }

  void _sortFlashcardsByWeight() {
    _flashcards.sort((a, b) => a.weight.compareTo(b.weight));
  }

  Widget _buildRemovedCardItem(Flashcard card, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          title: Text(card.question),
          subtitle: Text('Weight: ${card.weight}'),
        ),
      ),
    );
  }
}
