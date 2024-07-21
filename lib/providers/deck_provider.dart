import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindflasher/env_config.dart';

class DeckProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _deck = [];

  List<Map<String, dynamic>> get deck => _deck;

  Future<void> fetchDeck() async {
    String apiUrl = '${EnvConfig.mainApiUrl}api/decks';
    print("WWW  wapiUrl");
    print(apiUrl);
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      _deck = List<Map<String, dynamic>>.from(json.decode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to load subjects');
    }
  }
}
