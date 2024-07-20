import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../models/flashcard.dart';


class FlashcardListScreen extends StatefulWidget {
  @override
  _FlashcardListScreenState createState() => _FlashcardListScreenState();
}

class _FlashcardListScreenState extends State<FlashcardListScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final double _stopThresholdLeft = 0.3; // Порог остановки на 30% ширины экрана для левой стороны
  final double _stopThresholdRight = 0.9; // Порог остановки на 90% ширины экрана для правой стороны
  final double _irreversibleThresholdLeft = 0.07; // Порог необратимости для левой стороны
  final double _irreversibleThresholdRight = 0.30; // Порог необратимости для правой стороны

  void _removeItem(BuildContext context, FlashcardProvider provider, int index) {
    final flashcard = provider.flashcards[index];

    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildRemovedItem(flashcard, animation),
      duration: const Duration(milliseconds: 300),
    );

    provider.removeFlashcard(index);

    Future.delayed(const Duration(milliseconds: 300), () {
      _listKey.currentState?.insertItem(provider.flashcards.length, duration: const Duration(milliseconds: 300));
      provider.addFlashcard(flashcard);
    });
  }

  Widget _buildRemovedItem(Flashcard flashcard, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: ListTile(
          title: Text(flashcard.question),
          //subtitle: Text(flashcard.answer),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard List'),
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, provider, child) {
          return AnimatedList(
            key: _listKey,
            initialItemCount: provider.flashcards.length,
            itemBuilder: (context, index, animation) {
              if (index >= provider.flashcards.length) return SizedBox();
              final flashcard = provider.flashcards[index];
              return _buildItem(context, flashcard, index, animation);
            },
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, Flashcard flashcard, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: _SwipeableCard(
        flashcard: flashcard,
        onRemove: () => _removeItem(context, Provider.of<FlashcardProvider>(context, listen: false), index),
        stopThresholdLeft: _stopThresholdLeft,
        stopThresholdRight: _stopThresholdRight,
        irreversibleThresholdLeft: _irreversibleThresholdLeft,
        irreversibleThresholdRight: _irreversibleThresholdRight,
      ),
    );
  }
}

class _SwipeableCard extends StatefulWidget {
  final Flashcard flashcard;
  final VoidCallback onRemove;
  final double stopThresholdLeft;
  final double stopThresholdRight;
  final double irreversibleThresholdLeft;
  final double irreversibleThresholdRight;

  const _SwipeableCard({
    Key? key,
    required this.flashcard,
    required this.onRemove,
    required this.stopThresholdLeft,
    required this.stopThresholdRight,
    required this.irreversibleThresholdLeft,
    required this.irreversibleThresholdRight,
  }) : super(key: key);

  @override
  __SwipeableCardState createState() => __SwipeableCardState();
}

class __SwipeableCardState extends State<_SwipeableCard> {
  double _dragExtent = 0.0;

  void _handleDragUpdate(DragUpdateDetails details, BuildContext context) {
    setState(() {
      _dragExtent += details.primaryDelta!;
      final screenWidth = MediaQuery.of(context).size.width;
      final stopPositionLeft = screenWidth * widget.stopThresholdLeft;
      final stopPositionRight = screenWidth * widget.stopThresholdRight;
      if (_dragExtent > stopPositionLeft) {
        _dragExtent = stopPositionLeft;
      } else if (_dragExtent < -stopPositionRight) {
        _dragExtent = -stopPositionRight;
      }
    });
  }

  void _handleDragEnd(DragEndDetails details, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final stopPositionLeft = screenWidth * widget.stopThresholdLeft;
    final stopPositionRight = screenWidth * widget.stopThresholdRight;
    final irreversiblePositionLeft = screenWidth * widget.irreversibleThresholdLeft;
    final irreversiblePositionRight = screenWidth * widget.irreversibleThresholdRight;

    if (details.velocity.pixelsPerSecond.dx.abs() >= 800) {
      // Быстрый сдвиг
      setState(() {
        _dragExtent = _dragExtent > 0 ? stopPositionLeft : -stopPositionRight;
      });
    } else if (_dragExtent > 0 && _dragExtent >= irreversiblePositionLeft) {
      // Необратимый порог достигнут при движении вправо
      setState(() {
        _dragExtent = stopPositionLeft;
      });
    } else if (_dragExtent < 0 && _dragExtent.abs() >= irreversiblePositionRight) {
      // Необратимый порог достигнут при движении влево
      setState(() {
        _dragExtent = -stopPositionRight;
      });
    } else {
      // Вернуть назад, если не достигнуты пороги
      setState(() {
        _dragExtent = 0.0;
      });
    }
  }

  void _handleDismiss() {
    setState(() {
      _dragExtent = 0.0;
    });
    widget.onRemove();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) => _handleDragUpdate(details, context),
      onHorizontalDragEnd: (details) => _handleDragEnd(details, context),
      onTap: () {
        final screenWidth = MediaQuery.of(context).size.width;
        final stopPositionLeft = screenWidth * widget.stopThresholdLeft;
        final stopPositionRight = screenWidth * widget.stopThresholdRight;
        if (_dragExtent.abs() >= stopPositionLeft || _dragExtent.abs() >= stopPositionRight) {
          _handleDismiss();
        }
      },
      child: Stack(
        children: [
          if (_dragExtent > 0)
            _buildSwipeActionLeft(widget.flashcard, widget.stopThresholdLeft)
          else if (_dragExtent < 0)
            _buildSwipeActionRight(widget.flashcard, widget.stopThresholdRight),
          Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: Card(
              child: ListTile(
                title: Text(widget.flashcard.question),
                //subtitle: Text(widget.flashcard.answer),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeActionLeft(Flashcard flashcard, double stopThreshold) {
    return Positioned.fill(
      child: FractionallySizedBox(
        widthFactor: stopThreshold,
        alignment: Alignment.centerLeft,
        child: Container(
          color: Colors.greenAccent.withOpacity(0.3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Text('Left Swipe Action', style: TextStyle(color: Colors.black)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeActionRight(Flashcard flashcard, double stopThreshold) {
    return Positioned.fill(
      child: FractionallySizedBox(
        widthFactor: stopThreshold,
        alignment: Alignment.centerRight,
        child: Container(
          color: Colors.redAccent.withOpacity(0.3),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 10.0),
              child: Text(flashcard.answer, style: TextStyle(color: Colors.black)),
            ),
          ),
        ),
      ),
    );
  }
}
