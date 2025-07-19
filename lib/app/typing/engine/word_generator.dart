import 'dart:math';
import 'package:english_words/english_words.dart';

class WordGenerator {
  final Random _random = Random();

  // Custom word list to supplement english_words
  final List<String> _customWords = [
    'dad',
    'sad',
    'add',
    'fed',
    'led',
    'red',
    'sal',
    'jar',
    'far',
    'lad',
    // Add more words that fit your letterSubset
  ];

  List<String> generateWords({
    required Set<String> letterSubset,
    required Map<String, double> letterFrequencies,
    required int wordCount,
    int minWordLength = 3,
    int maxWordLength = 8,
  }) {
    // Combine custom words with english_words, filtering by letterSubset
    final validWords = <String>{..._customWords, ...all}
        .where(
          (word) =>
              word.length >= minWordLength &&
              word.length <= maxWordLength &&
              word.split('').every((char) => letterSubset.contains(char)),
        )
        .toList();

    // Optionally filter out inappropriate words
    final filteredWords = validWords.where((word) => word != 'ass').toList();

    final words = <String>[];
    for (int i = 0; i < wordCount; i++) {
      if (filteredWords.isEmpty) break;
      final word = _weightedRandomWord(filteredWords, letterFrequencies);
      words.add(word);
      filteredWords.remove(word); // Avoid duplicates
    }

    return words;
  }

  String _weightedRandomWord(
    List<String> words,
    Map<String, double> frequencies,
  ) {
    if (words.isEmpty) return '';

    double totalWeight = 0;
    for (final word in words) {
      double wordWeight = 1.0;
      for (final letter in word.split('')) {
        wordWeight *= frequencies[letter] ?? 1.0;
      }
      totalWeight += wordWeight;
    }

    double randomValue = _random.nextDouble() * totalWeight;
    double currentWeight = 0;

    for (final word in words) {
      double wordWeight = 1.0;
      for (final letter in word.split('')) {
        wordWeight *= frequencies[letter] ?? 1.0;
      }
      currentWeight += wordWeight;
      if (randomValue <= currentWeight) {
        return word;
      }
    }

    return words.last;
  }
}
