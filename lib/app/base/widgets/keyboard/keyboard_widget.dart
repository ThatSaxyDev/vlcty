import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlcty/app/base/widgets/keyboard/key_model.dart';
import 'package:vlcty/app/base/widgets/keyboard/key_press_notifier.dart';

class KeyboardWidget extends ConsumerStatefulWidget {
  static const height = 400.0;
  static const width = 1100.0;
  const KeyboardWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KeyboardWidgetState();
}

class _KeyboardWidgetState extends ConsumerState<KeyboardWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final keyPressState = ref.watch(keyboardPressProvider);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: KeyboardWidget.height,
        width: KeyboardWidget.width,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 150),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.white.withAlpha(5) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Colors.white.withAlpha(_isHovered ? 50 : 0),
            width: 1,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(40),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: keys
                .map(
                  (row) => Expanded(
                    child: Row(
                      children: row
                          .map(
                            (key) => Expanded(
                              flex: key.flex,
                              child: Container(
                                margin: EdgeInsets.all(1.5),
                                decoration: BoxDecoration(
                                  color: _getKeyColor(key, keyPressState),
                                ),
                                child: Center(
                                  child: Text(
                                    key.normalizedLabel,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: switch (key.normalizedLabel
                                          .toLowerCase()) {
                                        'tab' ||
                                        'caps lock' ||
                                        'alt' ||
                                        'ctrl' ||
                                        'backspace' ||
                                        'shift' ||
                                        'enter' => 14,
                                        _ => 16,
                                      },
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Color _getKeyColor(KeyModel key, KeyPressState keyPressState) {
    int baseAlpha = 60;

    if (key.label == 'Caps Lock' && keyPressState.isCapsLockEnabled) {
      return Colors.orange.withAlpha(180);
    }

    if (keyPressState.pressedKeys.contains(key.label)) {
      int increasedAlpha = (baseAlpha + keyPressState.alphaIncrease).clamp(
        0,
        255,
      );
      return key.color.withAlpha(increasedAlpha);
    }

    return key.color.withAlpha(baseAlpha);
  }
}
