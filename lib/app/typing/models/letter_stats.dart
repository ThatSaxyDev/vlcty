class LetterStats {
  final double averageTime;
  final int attempts;
  final double accuracy;

  LetterStats({
    required this.averageTime,
    required this.attempts,
    required this.accuracy,
  });

  LetterStats copyWith({
    double? averageTime,
    int? attempts,
    double? accuracy,
  }) {
    return LetterStats(
      averageTime: averageTime ?? this.averageTime,
      attempts: attempts ?? this.attempts,
      accuracy: accuracy ?? this.accuracy,
    );
  }
}