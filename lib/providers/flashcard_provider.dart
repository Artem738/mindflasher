import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mindflasher/screens/list/central_top_card.dart';
import 'package:mindflasher/screens/list/left_swipe_card.dart';
import 'package:mindflasher/screens/list/right_answer_card.dart';
import 'package:mindflasher/tech_data/weight_delays_enum.dart';
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

  Future<void> fetchAndPopulateFlashcards(int deckId) async {
    String apiUrl = 'http://176.37.2.137/api/decks/$deckId/flashcards';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _flashcards.clear(); // Очистим массив перед заполнением

      for (var item in data) {
        _flashcards.add(Flashcard(
          id: item['id'],
          question: item['question'],
          answer: item['answer'],
          weight: item['weight'] ?? 0, // Если weight отсутствует, используем 0
        ));
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load flashcards');
    }
  }

  void updateCardWeight(int id,  WeightDelaysEnum weightDelayEnum) {
    final index = _flashcards.indexWhere((card) => card.id == id);
    if (index != -1) {
      final flashcard = _flashcards[index];
      final updatedCard = flashcard.copyWith(weight: flashcard.weight + weightDelayEnum.value);

      listKey.currentState?.removeItem(
        index,
            (context, animation) => _buildRemovedCardItem(flashcard, animation, weightDelayEnum),
        duration: const Duration(milliseconds: 150),
      );

      _flashcards.removeAt(index);
      Future.delayed(const Duration(milliseconds: 10), () {
        _flashcards.add(updatedCard);
        _sortFlashcardsByWeight();
        final newIndex = _flashcards.indexOf(updatedCard);
        listKey.currentState?.insertItem(
          newIndex,
          duration: const Duration(milliseconds: 200),
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

  Widget _buildRemovedCardItem(Flashcard card, Animation<double> animation, WeightDelaysEnum weightDelayEnum) {
    if (weightDelayEnum == WeightDelaysEnum.noDelay) {
      return SizeTransition(
        sizeFactor: animation,
        child: LeftSwipeCard(
          flashcard: card,
          stopThreshold: 0.4, // DRY !!!!
        ),
      );
    } else if (weightDelayEnum == WeightDelaysEnum.badSmallDelay || weightDelayEnum == WeightDelaysEnum.normMedDelay) {
      return SizeTransition(
        sizeFactor: animation,
        child: RightAnswerCard(
          flashcard: card,
          stopThreshold: 0.9, // Пример значения для другого экрана
        ),
      );
    } else if (weightDelayEnum == WeightDelaysEnum.goodLongDelay) {
      return SizeTransition(
        sizeFactor: animation,
        child: CentralTopCard(
          flashcard: card,

        ),
      );
    } else {
      return SizeTransition(
        sizeFactor: animation,
        child: CentralTopCard(
          flashcard: card,
        ),
      );
    }
  }

}
