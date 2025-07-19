import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlcty/app/typing/models/typing_session.dart';
import 'package:vlcty/app/typing/notifiers/typing_session_notifier.dart';

class TextDisplay extends ConsumerStatefulWidget {
  const TextDisplay({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextDisplayState();
}

class _TextDisplayState extends ConsumerState<TextDisplay> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(typingSessionProvider);
    return Center(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: 1000,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withAlpha(5) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: _isHovered
                ? Border.all(color: Colors.white.withAlpha(50), width: 1)
                : null,
          ),
          child: Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 24,
                  height: 1.5,
                  color: Colors.white,
                ),
                children: _buildTextSpans(session),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(TypingSession session) {
    final spans = <TextSpan>[];
    final text = session.currentText;
    final typedLength = session.currentIndex;

    if (text.isEmpty) {
      return [const TextSpan(text: 'Loading...')];
    }

    // Correctly typed text (green)
    if (typedLength > 0) {
      spans.add(
        TextSpan(
          text: text.substring(0, typedLength).replaceAll(' ', ' · '),
          style: TextStyle(color: Colors.white.withAlpha(100)),
        ),
      );
    }

    // Current character (highlighted)
    if (typedLength < text.length) {
      final currentChar = text.substring(typedLength, typedLength + 1);
      spans.add(
        TextSpan(
          text: currentChar == ' ' ? ' · ' : currentChar,
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.white.withAlpha(150),
          ),
        ),
      );
    }

    // Remaining text (normal)
    if (typedLength + 1 < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(typedLength + 1).replaceAll(' ', ' · '),
          style: TextStyle(color: Colors.white.withAlpha(150)),
        ),
      );
    }

    return spans;
  }
}
