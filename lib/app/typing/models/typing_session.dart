// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vlcty/app/typing/models/letter_stats.dart';

class TypingSession {
  final Map<String, LetterStats> letterStats;
  final Set<String> currentSubset;
  final String? targetLetter; // Added to track the target letter
  final List<String> currentWords;
  final String currentText;
  final String typedText;
  final int currentIndex;
  final double wpm;
  final double cpm;
  final DateTime sessionStart;
  final bool isActive;
  final bool isLoading;

  TypingSession({
    required this.letterStats,
    required this.currentSubset,
    required this.targetLetter,
    required this.currentWords,
    required this.currentText,
    required this.typedText,
    required this.currentIndex,
    required this.wpm,
    required this.cpm,
    required this.sessionStart,
    required this.isActive,
    this.isLoading = false,
  });

  TypingSession.initial()
    : letterStats = {},
      currentSubset = {'e', 'n', 'i', 't', 'r', 'l'}, // Updated initial set
      targetLetter = null,
      currentWords = [],
      currentText = '',
      typedText = '',
      currentIndex = 0,
      wpm = 0,
      cpm = 0,
      sessionStart = DateTime.now(),
      isActive = false,
      isLoading = false;


  TypingSession copyWith({
    Map<String, LetterStats>? letterStats,
    Set<String>? currentSubset,
    String? targetLetter,
    List<String>? currentWords,
    String? currentText,
    String? typedText,
    int? currentIndex,
    double? wpm,
    double? cpm,
    DateTime? sessionStart,
    bool? isActive,
    bool? isLoading,
  }) {
    return TypingSession(
      letterStats: letterStats ?? this.letterStats,
      currentSubset: currentSubset ?? this.currentSubset,
      targetLetter: targetLetter ?? this.targetLetter,
      currentWords: currentWords ?? this.currentWords,
      currentText: currentText ?? this.currentText,
      typedText: typedText ?? this.typedText,
      currentIndex: currentIndex ?? this.currentIndex,
      wpm: wpm ?? this.wpm,
      cpm: cpm ?? this.cpm,
      sessionStart: sessionStart ?? this.sessionStart,
      isActive: isActive ?? this.isActive,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
