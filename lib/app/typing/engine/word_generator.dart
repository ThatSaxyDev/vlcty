import 'dart:math';
import 'package:all_english_words/all_english_words.dart';
import 'package:flutter/foundation.dart';

class WordGenerator {
  final Random _random = Random();
  final List<String> _allWords = [];

  Future<void> getWords() async {
    final englishWords = AllEnglishWords();

    if (_allWords.isNotEmpty) return;

    const chunkSize = 500;
    List<String> allWords = englishWords.englishWords;

    for (var i = 0; i < allWords.length; i += chunkSize) {
      final end = (i + chunkSize < allWords.length)
          ? i + chunkSize
          : allWords.length;
      final chunk = allWords.sublist(i, end);
      _allWords.addAll(chunk);

      await Future.delayed(Duration(milliseconds: 1));
    }
  }

  List<String> generateWords({
    required Set<String> letterSubset,
    required Map<String, double> letterFrequencies,
    required String? targetLetter,
    required int wordCount,
    int minWordLength = 3,
    int maxWordLength = 8,
  }) {
    // Combine custom words with english_words, filter by letterSubset and targetLetter
    final validWords = <String>{..._allWords}
        .where(
          (word) =>
              word.length >= minWordLength &&
              word.length <= maxWordLength &&
              word.split('').every((char) => letterSubset.contains(char)) &&
              (targetLetter == null || word.contains(targetLetter)),
        )
        .toList();

    // Filter out inappropriate words
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

    // Calculate weights based on letter frequencies
    double totalWeight = 0;
    final wordWeights = <String, double>{};
    for (final word in words) {
      double wordWeight = 1.0;
      for (final letter in word.split('')) {
        wordWeight *= frequencies[letter] ?? 1.0;
      }
      wordWeights[word] = wordWeight;
      totalWeight += wordWeight;
    }

    // Random selection based on weights
    double randomValue = _random.nextDouble() * totalWeight;
    double currentWeight = 0;

    for (final word in words) {
      currentWeight += wordWeights[word] ?? 1.0;
      if (randomValue <= currentWeight) {
        return word;
      }
    }

    return words.last;
  }
}
