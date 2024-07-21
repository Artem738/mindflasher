import 'package:flutter/material.dart';
import 'package:mindflasher/providers/deck_provider.dart';
import 'package:provider/provider.dart';

class DeckIndexScreen extends StatelessWidget {
  const DeckIndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects'),
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
                itemCount: deckProvider.deck.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(deckProvider.deck[i]['name']),
                  subtitle: Text(deckProvider.deck[i]['description']),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
