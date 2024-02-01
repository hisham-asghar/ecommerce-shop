/// Product review data
class Review {
  final double score; // from 1 to 5
  final String comment;
  final DateTime date;
  const Review({
    required this.score,
    required this.comment,
    required this.date,
  });

  Review copyWith({
    double? score,
    String? comment,
    DateTime? date,
  }) {
    return Review(
      score: score ?? this.score,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      score: map['score']?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }

  @override
  String toString() => 'Review(score: $score, comment: $comment, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Review &&
        other.score == score &&
        other.comment == comment &&
        other.date == date;
  }

  @override
  int get hashCode => score.hashCode ^ comment.hashCode ^ date.hashCode;
}
