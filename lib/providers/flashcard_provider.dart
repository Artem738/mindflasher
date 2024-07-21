import 'package:flutter/material.dart';
import 'package:mindflasher/tech_data/words_translations.dart';
import '../models/flashcard.dart';

class FlashcardProvider with ChangeNotifier {
  final List<Flashcard> _flashcards = [];
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  List<Flashcard> get flashcards => _flashcards;

  void populateFlashcards() {
    _flashcards.clear(); // Очистим массив перед заполнением
    int counter = 0; // Инициализируем счетчик

    for (var translation in WordsTranslations.translations) {
      translation.forEach((question, answer) {
        _flashcards.add(Flashcard(
          id: counter, // Используем счетчик как id
          question: question,
          answer: answer,
        ));
        counter++; // Увеличиваем счетчик после каждой итерации
      });
    }
    notifyListeners();
  }

  void updateCardWeight(int id, int increment) {
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
    _flashcards.sort((a, b) {
      int weightComparison = a.weight.compareTo(b.weight);
      if (weightComparison != 0) {
        return weightComparison;
      } else {
        return a.id.compareTo(b.id); // Сортировка по id если веса совпадают
      }
    });
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
