import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/deck.dart';
import '../env_config.dart';

class DeckProvider extends ChangeNotifier {
  List<Deck> _decks = [];

  List<Deck> get decks => _decks;

  Future<void> fetchDeck() async {
    String apiUrl = '${EnvConfig.mainApiUrl}api/decks';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _decks.clear();

      for (var item in data) {
        _decks.add(Deck(
          id: item['id'],
          name: item['name'],
          description: item['description'],
        ));
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load decks');
    }
  }
}
