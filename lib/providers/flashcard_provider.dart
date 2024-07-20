import 'package:flutter/material.dart';
import 'package:mindflasher/models/flashcard.dart';
import 'package:mindflasher/tech_data/words_translations.dart';

class FlashcardProvider with ChangeNotifier {
  final List<Flashcard> _flashcards = [];

  List<Flashcard> get flashcards => _flashcards;

  void addFlashcard(Flashcard flashcard) {
    _flashcards.add(flashcard);
    notifyListeners();
  }

  void removeFlashcard(int index) {
    _flashcards.removeAt(index);
    notifyListeners();
  }

  void moveFlashcardToEnd(Flashcard flashcard) {
    _flashcards.add(flashcard);
    notifyListeners();
  }

  void populateFlashcards(int count) {
    final wordTranslations = WordsTranslations.translations;

    for (int i = 0; i < count && i < wordTranslations.length; i++) {
      final wordPair = wordTranslations[i];
      final englishWord = wordPair.keys.first;
      final russianTranslation = wordPair.values.first;
      _flashcards.add(Flashcard(
        question: englishWord,
        answer: russianTranslation,
      ));
    }
    notifyListeners();
  }
}
