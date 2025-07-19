import 'package:vlcty/app/typing/models/letter_stats.dart';

class AdaptiveAlgorithm {
  static const double _targetAccuracy = 0.80; // Lowered from 0.85
  static const double _targetTimeThreshold = 400; // Increased from 300ms
  static const int _minAttemptsForProgression = 10; // Lowered from 20

  final List<String> _letterProgression = [
    'a', 's', 'd', 'f', // Home row left
    'j', 'k', 'l', ';', // Home row right
    'g', 'h', // Home row center
    'r', 'u', 'e', 'i', // Top row common
    'n', 't', 'o', // Most frequent
    'c', 'v', 'm', // Bottom row
    'w', 'p', 'y', 'q', // Top row remaining
    'x', 'z', 'b', // Bottom row remaining
  ];

  Set<String> getNextSubset(
    Map<String, LetterStats> currentStats,
    Set<String> currentSubset,
  ) {
    // Always include a minimum set of letters to ensure enough words
    final minimumLetters = {
      'a',
      's',
      'd',
      'f',
      'j',
      'k',
      'l',
      'e',
      'r',
    }; // Expanded initial set
    Set<String> newSubset = {...currentSubset, ...minimumLetters};

    bool canProgress = _canProgressToNextLevel(currentStats, currentSubset);

    if (canProgress && newSubset.length < _letterProgression.length) {
      for (final letter in _letterProgression) {
        if (!newSubset.contains(letter)) {
          newSubset.add(letter);
          break; // Add one new letter at a time
        }
      }
    }

    return newSubset;
  }

  Map<String, double> calculateLetterFrequencies(
    Map<String, LetterStats> stats,
    Set<String> currentSubset,
    Set<String> newLetters,
  ) {
    final frequencies = <String, double>{};

    for (final letter in currentSubset) {
      frequencies[letter] = 1.0;
    }

    for (final letter in newLetters) {
      frequencies[letter] = 3.0;
    }

    for (final letter in currentSubset) {
      final stat = stats[letter];
      if (stat != null) {
        if (stat.averageTime > _targetTimeThreshold ||
            stat.accuracy < _targetAccuracy) {
          frequencies[letter] = (frequencies[letter] ?? 1.0) * 2.0;
        }
      }
    }

    return frequencies;
  }

  bool _canProgressToNextLevel(
    Map<String, LetterStats> stats,
    Set<String> subset,
  ) {
    for (final letter in subset) {
      final stat = stats[letter];
      if (stat == null) return false;

      if (stat.attempts < _minAttemptsForProgression) return false;
      if (stat.averageTime > _targetTimeThreshold) return false;
      if (stat.accuracy < _targetAccuracy) return false;
    }

    return true;
  }
}
