import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vlcty/app/typing/models/letter_stats.dart';

class AdaptiveAlgorithm {
  static const double _targetAccuracy = 0.75;
  static const double _targetTimeThreshold = 460;
  static const int _minAttemptsForProgression = 10;
  static const double _yellowAccuracyThreshold = 0.675; //! 90% of 0.75
  static const double _yellowTimeThreshold = 552; //! 120% of 460ms
  static const int _maxLessonsForTarget = 7; //! rotate after 4 lessons

  final List<String> _letterProgression = [
    'e', 'n', 'i', 't', 'r', 'l', //! initial set
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

  //! track target letter persistence
  String? _previousTargetLetter;
  int _targetLetterCount = 0;

  //! determine the current letter subset and target letter
  ({Set<String> subset, String? targetLetter}) getNextSubset(
    Map<String, LetterStats> currentStats,
    Set<String> currentSubset,
  ) {
    //! ensure initial letters are included
    final minimumLetters = {'e', 'n', 'i', 't', 'r', 'l'};
    Set<String> newSubset = {...currentSubset, ...minimumLetters};

    //! find the target letter
    String? targetLetter = _findTargetLetter(currentStats, newSubset);

    //! rotate target letter if stuck for too long
    if (targetLetter == _previousTargetLetter) {
      _targetLetterCount++;
      if (_targetLetterCount >= _maxLessonsForTarget && newSubset.length > 1) {
        //! pick a different letter with sufficient attempts
        final eligibleLetters = newSubset
            .where(
              (letter) =>
                  letter != targetLetter &&
                  (currentStats[letter]?.attempts ?? 0) >=
                      _minAttemptsForProgression,
            )
            .toList();
        if (eligibleLetters.isNotEmpty) {
          targetLetter =
              eligibleLetters[Random().nextInt(eligibleLetters.length)];
          _targetLetterCount = 0; //! reset counter
        }
      }
    } else {
      _previousTargetLetter = targetLetter;
      _targetLetterCount = 1;
    }

    //! check if the current subset is mastered
    bool canProgress = _canProgressToNextLevel(currentStats, newSubset);

    if (canProgress && newSubset.length < _letterProgression.length) {
      //! add the next letter from the progression
      for (final letter in _letterProgression) {
        if (!newSubset.contains(letter)) {
          newSubset.add(letter);
          targetLetter = letter; //! new letter becomes the target
          _previousTargetLetter = letter;
          _targetLetterCount = 1;
          break;
        }
      }
    }

    return (subset: newSubset, targetLetter: targetLetter);
  }

  //! calculate letter frequencies, boosting the target letter
  Map<String, double> calculateLetterFrequencies(
    Map<String, LetterStats> stats,
    Set<String> currentSubset,
    String? targetLetter,
  ) {
    final frequencies = <String, double>{};

    //! base frequency for all letters in subset
    for (final letter in currentSubset) {
      frequencies[letter] = 1.0;
    }

    //! boost frequency for letters needing practice
    for (final letter in currentSubset) {
      final stat = stats[letter];
      if (stat != null) {
        if (stat.averageTime > _targetTimeThreshold ||
            stat.accuracy < _targetAccuracy) {
          frequencies[letter] = (frequencies[letter] ?? 1.0) * 2.0;
        }
      }
    }

    //! significantly boost the target letter to ensure it appears
    if (targetLetter != null) {
      frequencies[targetLetter] = (frequencies[targetLetter] ?? 1.0) * 5.0;
    }

    return frequencies;
  }

  //! find the letter with the worst typing speed (highest average time)
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

  //! check if the current subset is mastered
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

  //! determine indicator color for a letter
  Color getIndicatorColor(String letter, Map<String, LetterStats> stats) {
    final stat = stats[letter];
    if (stat == null || stat.attempts < _minAttemptsForProgression) {
      return Colors.grey.withAlpha(150); //! unknown stats
    }
    if (stat.averageTime <= _targetTimeThreshold &&
        stat.accuracy >= _targetAccuracy) {
      return Colors.green.withAlpha(150); //! mastered
    }
    if (stat.averageTime <= _yellowTimeThreshold &&
        stat.accuracy >= _yellowAccuracyThreshold) {
      return Colors.yellow.withAlpha(120); //! in progress (close to mastery)
    }
    return Colors.red.withAlpha(150); //! needs improvement
  }
}

final List<String> letterProgression = [
  'e',
  'n',
  'i',
  't',
  'r',
  'l',
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
