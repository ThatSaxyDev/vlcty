import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlcty/app/typing/engine/adaptive_algorithm.dart';
import 'package:vlcty/app/typing/engine/word_generator.dart';
import 'package:vlcty/app/typing/models/letter_stats.dart';
import 'package:vlcty/app/typing/models/typing_session.dart';

class TypingSessionNotifier extends Notifier<TypingSession> {
  @override
  TypingSession build() {
    final initialState = TypingSession.initial();

    Future.microtask(() {
      _initializeSession();
    });

    return initialState;
  }

  final WordGenerator _wordGenerator = WordGenerator();
  final AdaptiveAlgorithm _algorithm = AdaptiveAlgorithm();
  DateTime? _lastKeystroke;

  void _initializeSession() {
    _generateNewLesson();
  }

  void _generateNewLesson() {
    final (:subset, :targetLetter) = _algorithm.getNextSubset(
      state.letterStats,
      state.currentSubset,
    );

    final frequencies = _algorithm.calculateLetterFrequencies(
      state.letterStats,
      subset,
      targetLetter,
    );

    // Log the current letterSubset and targetLetter
    print('Current letterSubset: $subset');
    print('Target letter: $targetLetter');

    final words = _wordGenerator.generateWords(
      letterSubset: subset,
      letterFrequencies: frequencies,
      targetLetter: targetLetter,
      wordCount: 20,
    );

    // Log the generated words
    print('Generated words: $words');

    final text = words.join(' ');

    state = state.copyWith(
      currentSubset: subset,
      targetLetter: targetLetter,
      currentWords: words,
      currentText: text,
      typedText: '',
      currentIndex: 0,
      sessionStart: DateTime.now(),
      isActive: true,
    );
  }

  void onKeyPressed(String key) {
    if (!state.isActive || state.currentIndex >= state.currentText.length) {
      return;
    }

    final now = DateTime.now();
    final expectedChar = state.currentText[state.currentIndex];
    final isCorrect = key.toLowerCase() == expectedChar.toLowerCase();

    // Calculate time for this keystroke
    double keystrokeTime = 0;
    if (_lastKeystroke != null) {
      keystrokeTime = now.difference(_lastKeystroke!).inMilliseconds.toDouble();
    }
    _lastKeystroke = now;

    // Update letter statistics
    _updateLetterStats(expectedChar.toLowerCase(), keystrokeTime, isCorrect);

    if (isCorrect) {
      // Advance to next character
      state = state.copyWith(
        typedText: state.typedText + key,
        currentIndex: state.currentIndex + 1,
      );

      // Check if lesson is complete
      if (state.currentIndex >= state.currentText.length) {
        _completeLesson();
      }
    }

    // Update speed metrics
    _updateSpeedMetrics();
  }

  void _updateLetterStats(String letter, double time, bool isCorrect) {
    final currentStats = Map<String, LetterStats>.from(state.letterStats);
    final existing = currentStats[letter];

    if (existing == null) {
      currentStats[letter] = LetterStats(
        averageTime: time,
        attempts: 1,
        accuracy: isCorrect ? 1.0 : 0.0,
      );
    } else {
      final newAttempts = existing.attempts + 1;
      final newAverageTime =
          ((existing.averageTime * existing.attempts) + time) / newAttempts;
      final newAccuracy =
          ((existing.accuracy * existing.attempts) + (isCorrect ? 1.0 : 0.0)) /
          newAttempts;

      currentStats[letter] = existing.copyWith(
        averageTime: newAverageTime,
        attempts: newAttempts,
        accuracy: newAccuracy,
      );
    }

    state = state.copyWith(letterStats: currentStats);
  }

  void _updateSpeedMetrics() {
    final elapsed =
        DateTime.now().difference(state.sessionStart).inMilliseconds / 1000.0;
    if (elapsed > 0) {
      final charactersTyped = state.currentIndex;
      final cpm = (charactersTyped / elapsed) * 60.0;
      final wpm = cpm / 5.0;

      state = state.copyWith(cpm: cpm, wpm: wpm);
    }
  }

  void _completeLesson() {
    state = state.copyWith(isActive: false);

    // Auto-generate next lesson after a brief delay
    Future.delayed(const Duration(seconds: 2), () {
      _generateNewLesson();
    });
  }

  void startNewLesson() {
    _generateNewLesson();
  }

  void resetProgress() {
    state = TypingSession.initial();
    _initializeSession();
  }

  // Helper method to get indicator color for UI
  Color getIndicatorColor(String letter) {
    return _algorithm.getIndicatorColor(letter, state.letterStats);
  }
}

final typingSessionProvider =
    NotifierProvider<TypingSessionNotifier, TypingSession>(() {
      return TypingSessionNotifier();
    });
