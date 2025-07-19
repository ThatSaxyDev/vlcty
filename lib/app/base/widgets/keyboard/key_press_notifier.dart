import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final keyboardPressProvider =
    NotifierProvider<KeyboardPressNotifier, KeyPressState>(() {
      return KeyboardPressNotifier();
    });

class KeyboardPressNotifier extends Notifier<KeyPressState> {
  @override
  KeyPressState build() {
    bool isCapsLockOn = HardwareKeyboard.instance.lockModesEnabled.contains(
      KeyboardLockMode.capsLock,
    );
    return KeyPressState(isCapsLockEnabled: isCapsLockOn);
  }

  void onKeyDown(String key) {
    String normalizedKey = _normalizeKey(key);

    Set<String> newPressedKeys = Set.from(state.pressedKeys);
    newPressedKeys.add(normalizedKey);

    bool isCapsLockOn = HardwareKeyboard.instance.lockModesEnabled.contains(
      KeyboardLockMode.capsLock,
    );

    state = state.copyWith(
      pressedKeys: newPressedKeys,
      isCapsLockEnabled: isCapsLockOn,
    );
  }

  void onKeyUp(String key) {
    String normalizedKey = _normalizeKey(key);

    Set<String> newPressedKeys = Set.from(state.pressedKeys);
    newPressedKeys.remove(normalizedKey);

    // Check Caps Lock state and update
    bool isCapsLockOn = HardwareKeyboard.instance.lockModesEnabled.contains(
      KeyboardLockMode.capsLock,
    );

    state = state.copyWith(
      pressedKeys: newPressedKeys,
      isCapsLockEnabled: isCapsLockOn,
    );
  }

  String _normalizeKey(String key) {
    // Map physical keys to display labels that match your KeyModel labels exactly
    switch (key.toLowerCase()) {
      case ' ':
        return '';
      case '`':
        return '~\n`';
      case '1':
        return '!\n1';
      case '2':
        return '@\n2';
      case '3':
        return '#\n3';
      case '4':
        return '\$\n4';
      case '5':
        return '%\n5';
      case '6':
        return '^\n6';
      case '7':
        return '&\n7';
      case '8':
        return '*\n8';
      case '9':
        return '(\n9';
      case '0':
        return ')\n0';
      case '-':
        return '_\n-';
      case '=':
        return '+\n=';
      case 'backspace':
        return 'Backspace';
      case 'tab':
        return 'Tab';
      case '[':
        return '{\n[';
      case ']':
        return '}\n]';
      case '\\':
        return '|\n\\';
      case 'Caps Lock':
        return 'Caps Lock';
      case ';':
        return ':\n;';
      case '\'':
        return '"\n\'';
      case 'enter':
        return 'Enter';

      case 'shift left':
        return 'Shift left';
      case 'shift right':
        return 'Shift right';
      case ',':
        return ',\n<';
      case '.':
        return '.\n>';
      case '/':
        return '/\n?';

      case 'control left':
        return 'Ctrl left';
      case 'control right':
        return 'Ctrl right';

      case 'alt left':
        return 'Alt left';
      case 'alt right':
        return 'Alt right';
      case 'keya':
      case 'a':
        return 'A';
      case 'keyb':
      case 'b':
        return 'B';
      case 'keyc':
      case 'c':
        return 'C';
      case 'keyd':
      case 'd':
        return 'D';
      case 'keye':
      case 'e':
        return 'E';
      case 'keyf':
      case 'f':
        return 'F';
      case 'keyg':
      case 'g':
        return 'G';
      case 'keyh':
      case 'h':
        return 'H';
      case 'keyi':
      case 'i':
        return 'I';
      case 'keyj':
      case 'j':
        return 'J';
      case 'keyk':
      case 'k':
        return 'K';
      case 'keyl':
      case 'l':
        return 'L';
      case 'keym':
      case 'm':
        return 'M';
      case 'keyn':
      case 'n':
        return 'N';
      case 'keyo':
      case 'o':
        return 'O';
      case 'keyp':
      case 'p':
        return 'P';
      case 'keyq':
      case 'q':
        return 'Q';
      case 'keyr':
      case 'r':
        return 'R';
      case 'keys':
      case 's':
        return 'S';
      case 'keyt':
      case 't':
        return 'T';
      case 'keyu':
      case 'u':
        return 'U';
      case 'keyv':
      case 'v':
        return 'V';
      case 'keyw':
      case 'w':
        return 'W';
      case 'keyx':
      case 'x':
        return 'X';
      case 'keyy':
      case 'y':
        return 'Y';
      case 'keyz':
      case 'z':
        return 'Z';
      default:
        // Fallback: try to match the key as-is, then uppercase
        String fallback = key.length == 1 ? key.toUpperCase() : key;
        return fallback;
    }
  }
}

class KeyPressState {
  final Set<String> pressedKeys;
  final int alphaIncrease;
  final bool isCapsLockEnabled;

  const KeyPressState({
    this.pressedKeys = const {},
    this.alphaIncrease = 200,
    this.isCapsLockEnabled = false,
  });

  KeyPressState copyWith({
    Set<String>? pressedKeys,
    int? alphaIncrease,
    bool? isCapsLockEnabled,
  }) {
    return KeyPressState(
      pressedKeys: pressedKeys ?? this.pressedKeys,
      alphaIncrease: alphaIncrease ?? this.alphaIncrease,
      isCapsLockEnabled: isCapsLockEnabled ?? this.isCapsLockEnabled,
    );
  }
}
