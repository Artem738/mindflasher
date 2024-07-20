import 'package:flutter/material.dart';
import 'package:mindflasher/screens/list/flashcard_list_screen.dart';
import 'package:provider/provider.dart';
import 'providers/flashcard_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlashcardProvider()..populateFlashcards(10)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App',
      home: FlashcardListScreen(),

    );
  }
}