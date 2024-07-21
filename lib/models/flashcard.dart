class Flashcard {
  final String id;
  final String question;
  final String answer;
  final int weight; // вес карточки

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.weight = 0, // начальный вес
  });

  Flashcard copyWith({
    String? id,
    String? question,
    String? answer,
    int? weight,
  }) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      weight: weight ?? this.weight,
    );
  }
}
