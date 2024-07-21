import 'package:flutter/material.dart';
import 'package:mindflasher/providers/deck_provider.dart';
import 'package:mindflasher/screens/deck/deck_index_screen.dart';
import 'package:mindflasher/screens/list/flashcard_index_screen.dart';
import 'package:provider/provider.dart';
import 'env_config.dart';
import 'providers/flashcard_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlashcardProvider()),
        ChangeNotifierProvider(create: (_) => DeckProvider()),
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
      debugShowCheckedModeBanner: EnvConfig.showDebugUpRightBanner,
      title: 'Flashcard App',
      home: DeckIndexScreen(),
      routes: {
        '/deck': (context) => DeckIndexScreen(),
      },
    );
  }
}
