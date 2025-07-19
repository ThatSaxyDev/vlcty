import 'package:vlcty/app/typing/models/letter_stats.dart';

class AdaptiveAlgorithm {
  static const double _targetAccuracy =
      0.80; // 80% accuracy to consider a letter mastered
  static const double _targetTimeThreshold = 400; // 400ms for fast typing
  static const int _minAttemptsForProgression =
      10; // Minimum attempts before progression

  final List<String> _letterProgression = [
    'e', 'n', 'i', 't', 'r', 'l', // Initial set
    's',
    'a',
    'u',
    'o',
    'd',
    'y',
    'c',
    'h',
    'g',
    'm',
    'p',
    'b',
    'k',
    'v',
    'w',
    'f',
    'z',
    'x',
    'q',
    'j',
  ];

  // Determine the current letter subset and target letter
  ({Set<String> subset, String? targetLetter}) getNextSubset(
    Map<String, LetterStats> currentStats,
    Set<String> currentSubset,
  ) {
    // Ensure initial letters are included
    final minimumLetters = {'e', 'n', 'i', 't', 'r', 'l'};
    Set<String> newSubset = {...currentSubset, ...minimumLetters};

    // Find the target letter (worst performing based on speed)
    String? targetLetter = _findTargetLetter(currentStats, newSubset);

    // Check if the current subset is mastered
    bool canProgress = _canProgressToNextLevel(currentStats, newSubset);

    if (canProgress && newSubset.length < _letterProgression.length) {
      // Add the next letter from the progression
      for (final letter in _letterProgression) {
        if (!newSubset.contains(letter)) {
          newSubset.add(letter);
          targetLetter = letter; // New letter becomes the target
          break;
        }
      }
    }

    return (subset: newSubset, targetLetter: targetLetter);
  }

  // Calculate letter frequencies, boosting the target letter
  Map<String, double> calculateLetterFrequencies(
    Map<String, LetterStats> stats,
    Set<String> currentSubset,
    String? targetLetter,
  ) {
    final frequencies = <String, double>{};

    // Base frequency for all letters in subset
    for (final letter in currentSubset) {
      frequencies[letter] = 1.0;
    }

    // Boost frequency for letters needing practice
    for (final letter in currentSubset) {
      final stat = stats[letter];
      if (stat != null) {
        if (stat.averageTime > _targetTimeThreshold ||
            stat.accuracy < _targetAccuracy) {
          frequencies[letter] = (frequencies[letter] ?? 1.0) * 2.0;
        }
      }
    }

    // Significantly boost the target letter to ensure it appears
    if (targetLetter != null) {
      frequencies[targetLetter] = (frequencies[targetLetter] ?? 1) * 5.0;
    }

    return frequencies;
  }

  // Find the letter with the worst typing speed (highest average time)
  String? _findTargetLetter(
    Map<String, LetterStats> stats,
    Set<String> subset,
  ) {
    String? targetLetter;
    double maxTime = 0;

    for (final letter in subset) {
      final stat = stats[letter];
      if (stat != null && stat.attempts >= _minAttemptsForProgression) {
        if (stat.averageTime > maxTime) {
          maxTime = stat.averageTime;
          targetLetter = letter;
        }
      }
    }

    return targetLetter;
  }

  // Check if the current subset is mastered
  bool _canProgressToNextLevel(
    Map<String, LetterStats> stats,
    Set<String> subset,
  ) {
    for (final letter in subset) {
      final stat = stats[letter];
      if (stat == null || stat.attempts < _minAttemptsForProgression) {
        return false;
      }
      if (stat.averageTime > _targetTimeThreshold ||
          stat.accuracy < _targetAccuracy) {
        return false;
      }
    }
    return true;
  }

  // Determine indicator color for a letter
  String getIndicatorColor(String letter, Map<String, LetterStats> stats) {
    final stat = stats[letter];
    if (stat == null || stat.attempts < _minAttemptsForProgression) {
      return 'gray'; // Unknown stats
    }
    if (stat.averageTime > _targetTimeThreshold ||
        stat.accuracy < _targetAccuracy) {
      return 'red'; // Slow or low accuracy
    }
    return 'green'; // Mastered
  }
}
