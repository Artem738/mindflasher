import 'package:flutter/material.dart';
import 'package:mindflasher/providers/deck_provider.dart';
import 'package:mindflasher/providers/user_provider.dart';
import 'package:mindflasher/screens/list/flashcard_index_screen.dart';
import 'package:provider/provider.dart';

class DeckIndexScreen extends StatelessWidget {
  const DeckIndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deck'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false).logout,
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<DeckProvider>(context, listen: false).fetchDeck(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            return Consumer<DeckProvider>(
              builder: (ctx, deckProvider, child) => ListView.builder(
                itemCount: deckProvider.decks.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(deckProvider.decks[i].name),
                  subtitle: Text(deckProvider.decks[i].description),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FlashcardIndexScreen(deck: deckProvider.decks[i]),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
