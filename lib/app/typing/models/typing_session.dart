import 'package:vlcty/app/typing/models/letter_stats.dart';

class TypingSession {
  final Map<String, LetterStats> letterStats;
  final Set<String> currentSubset;
  final List<String> currentWords;
  final String currentText;
  final String typedText;
  final int currentIndex;
  final double wpm;
  final double cpm;
  final DateTime sessionStart;
  final bool isActive;

  TypingSession({
    required this.letterStats,
    required this.currentSubset,
    required this.currentWords,
    required this.currentText,
    required this.typedText,
    required this.currentIndex,
    required this.wpm,
    required this.cpm,
    required this.sessionStart,
    required this.isActive,
  });

  TypingSession.initial()
      : letterStats = {},
        currentSubset = {'a', 's', 'd', 'f'},
        currentWords = [],
        currentText = '',
        typedText = '',
        currentIndex = 0,
        wpm = 0,
        cpm = 0,
        sessionStart = DateTime.now(),
        isActive = false;

  TypingSession copyWith({
    Map<String, LetterStats>? letterStats,
    Set<String>? currentSubset,
    List<String>? currentWords,
    String? currentText,
    String? typedText,
    int? currentIndex,
    double? wpm,
    double? cpm,
    DateTime? sessionStart,
    bool? isActive,
  }) {
    return TypingSession(
      letterStats: letterStats ?? this.letterStats,
      currentSubset: currentSubset ?? this.currentSubset,
      currentWords: currentWords ?? this.currentWords,
      currentText: currentText ?? this.currentText,
      typedText: typedText ?? this.typedText,
      currentIndex: currentIndex ?? this.currentIndex,
      wpm: wpm ?? this.wpm,
      cpm: cpm ?? this.cpm,
      sessionStart: sessionStart ?? this.sessionStart,
      isActive: isActive ?? this.isActive,
    );
  }
}