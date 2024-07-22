import 'package:flutter/material.dart';
import 'package:mindflasher/providers/deck_provider.dart';
import 'package:mindflasher/providers/user_provider.dart';
import 'package:mindflasher/screens/deck/deck_index_screen.dart';
import 'package:mindflasher/screens/user/login_screen.dart';
import 'package:mindflasher/screens/user/register_screen.dart';
import 'package:provider/provider.dart';
import 'env_config.dart';
import 'providers/flashcard_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlashcardProvider()),
        ChangeNotifierProvider(create: (_) => DeckProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    bool isLoggedIn = userProvider.token != null && userProvider.user != null;

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: EnvConfig.showDebugUpRightBanner,
      title: 'Flashcard App',
      home: isLoggedIn ? DeckIndexScreen() : LoginScreen(),
      routes: {
        '/deck': (context) => DeckIndexScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
