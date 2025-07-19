import 'package:flutter/material.dart';

class KeyModel {
  final String label;
  final Color color;
  final int flex;

  KeyModel({required this.label, required this.color, this.flex = 1});
}

extension KeyModelExtension on KeyModel {
  String get normalizedLabel {
    List<String> words = label.split(' ');

    if (words.isNotEmpty) {
      String lastWord = words.last.toLowerCase();
      if (lastWord == 'right' || lastWord == 'left') {
        words.removeLast();
        return words.join(' ');
      }
    }

    return label;
  }
}

final List<List<KeyModel>> keys = [
  [
    KeyModel(label: '~\n`', color: Colors.green),
    KeyModel(label: '!\n1', color: Colors.green),
    KeyModel(label: '@\n2', color: Colors.green[800]!),
    KeyModel(label: '#\n3', color: Colors.orange),
    KeyModel(label: '\$\n4', color: Colors.teal),
    KeyModel(label: '%\n5', color: Colors.teal),
    KeyModel(label: '^\n6', color: Colors.purple),
    KeyModel(label: '&\n7', color: Colors.purple),
    KeyModel(label: '*\n8', color: Colors.orange),
    KeyModel(label: '(\n9', color: Colors.green[800]!),
    KeyModel(label: ')\n0', color: Colors.green),
    KeyModel(label: '_\n-', color: Colors.green),
    KeyModel(label: '+\n=', color: Colors.green),
    KeyModel(label: 'Backspace', color: Colors.green, flex: 2),
  ],
  [
    KeyModel(label: 'Tab', color: Colors.green, flex: 2),
    KeyModel(label: 'Q', color: Colors.green),
    KeyModel(label: 'W', color: Colors.green[800]!),
    KeyModel(label: 'E', color: Colors.orange),
    KeyModel(label: 'R', color: Colors.teal),
    KeyModel(label: 'T', color: Colors.teal),
    KeyModel(label: 'Y', color: Colors.purple),
    KeyModel(label: 'U', color: Colors.purple),
    KeyModel(label: 'I', color: Colors.orange),
    KeyModel(label: 'O', color: Colors.green[800]!),
    KeyModel(label: 'P', color: Colors.green),
    KeyModel(label: '{\n[', color: Colors.green),
    KeyModel(label: '}\n]', color: Colors.green),
    KeyModel(label: '|\n\\', color: Colors.green),
  ],
  [
    KeyModel(label: 'Caps Lock', color: Colors.green, flex: 2),
    KeyModel(label: 'A', color: Colors.green),
    KeyModel(label: 'S', color: Colors.green[800]!),
    KeyModel(label: 'D', color: Colors.orange),
    KeyModel(label: 'F', color: Colors.teal),
    KeyModel(label: 'G', color: Colors.teal),
    KeyModel(label: 'H', color: Colors.purple),
    KeyModel(label: 'J', color: Colors.purple),
    KeyModel(label: 'K', color: Colors.orange),
    KeyModel(label: 'L', color: Colors.green[800]!),
    KeyModel(label: ':\n;', color: Colors.green),
    KeyModel(label: '"\n\'', color: Colors.green),
    KeyModel(label: 'Enter', color: Colors.green, flex: 2),
  ],
  [
    KeyModel(label: 'Shift left', color: Colors.green, flex: 2),
    KeyModel(label: 'Z', color: Colors.green),
    KeyModel(label: 'X', color: Colors.green[800]!),
    KeyModel(label: 'C', color: Colors.orange),
    KeyModel(label: 'V', color: Colors.teal),
    KeyModel(label: 'B', color: Colors.teal),
    KeyModel(label: 'N', color: Colors.purple),
    KeyModel(label: 'M', color: Colors.purple),
    KeyModel(label: ',\n<', color: Colors.orange),
    KeyModel(label: '.\n>', color: Colors.green[800]!),
    KeyModel(label: '/\n?', color: Colors.green),
    KeyModel(label: 'Shift right', color: Colors.green, flex: 2),
  ],
  [
    KeyModel(label: 'Ctrl left', color: Colors.green),
    KeyModel(label: 'Alt left', color: Colors.green),
    KeyModel(label: '', color: Colors.red, flex: 6), // Spacebar
    KeyModel(label: 'Alt right', color: Colors.green),
    KeyModel(label: 'Ctrl right', color: Colors.green),
  ],
];
