import 'package:flutter/material.dart';
import 'package:mindflasher/models/flashcard.dart';

class CentralTopCard extends StatelessWidget {
  final Flashcard flashcard;
  final VoidCallback onRemove;

  const CentralTopCard({Key? key, required this.flashcard, required this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Изменено на center
          children: [
            // Колонка с кнопками
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40, // Ширина кнопки
                  child: ElevatedButton(
                    onPressed: () {
                      onRemove();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Задаем цвет фона кнопки
                      padding: EdgeInsets.zero, // Убираем внутренние отступы
                    ),
                    child: Center(
                      child: Icon(Icons.check),
                    ),
                  ),
                ),
                SizedBox(height: 8.0), // Отступ между кнопками
              ],
            ),
            SizedBox(width: 8.0), // Отступ между кнопками и текстом
            // Текст
            Expanded(
              child: Text(
                flashcard.question,
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
