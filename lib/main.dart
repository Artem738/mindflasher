import 'package:flutter/material.dart';
import 'package:mindflasher/screens/list/flashcard_list_screen.dart';
import 'package:provider/provider.dart';
import 'env_config.dart';
import 'providers/flashcard_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlashcardProvider()..populateFlashcards()),
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
      home: FlashcardListScreen(),
    );
  }
}
