import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:vlcty/app/base/widgets/base_view_display.dart';
import 'package:vlcty/app/base/widgets/keyboard/key_press_notifier.dart';
import 'package:vlcty/app/base/widgets/keyboard/keyboard_widget.dart';
import 'package:vlcty/app/typing/notifiers/typing_session_notifier.dart';
import 'package:vlcty/theme/app_colors.dart';

final containerPositionProvider = StateProvider<Offset>((ref) => Offset.zero);

class BaseView extends ConsumerStatefulWidget {
  const BaseView({super.key});

  @override
  ConsumerState<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends ConsumerState<BaseView> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(containerPositionProvider);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: Focus(
          focusNode: _focusNode,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              ref
                  .read(keyboardPressProvider.notifier)
                  .onKeyDown(event.logicalKey.keyLabel);

              if (event.character != null) {
                ref
                    .read(typingSessionProvider.notifier)
                    .onKeyPressed(event.character!);
              }
            } else if (event is KeyUpEvent) {
              ref
                  .read(keyboardPressProvider.notifier)
                  .onKeyUp(event.logicalKey.keyLabel);
            }
            return KeyEventResult.handled;
          },
          child: Stack(
            children: [
              BaseViewDisplay(),
              Positioned(
                left:
                    position.dx +
                    (screenSize.width / 2) -
                    (KeyboardWidget.width / 2),
                top:
                    position.dy +
                    (screenSize.height / 2) -
                    (KeyboardWidget.height / 2),

                child: GestureDetector(
                  onPanUpdate: (details) {
                    //! calculate new position
                    final newPosition = position + details.delta;

                    //! clamp position to screen boundaries
                    final clampedX =
                        (newPosition.dx +
                                (screenSize.width / 2) -
                                (KeyboardWidget.width / 2))
                            .clamp(
                              0.0,
                              screenSize.width - KeyboardWidget.width,
                            ) -
                        (screenSize.width / 2) +
                        (KeyboardWidget.width / 2);
                    final clampedY =
                        (newPosition.dy +
                                (screenSize.height / 2) -
                                (KeyboardWidget.height / 2))
                            .clamp(
                              0.0,
                              screenSize.height - KeyboardWidget.height,
                            ) -
                        (screenSize.height / 2) +
                        (KeyboardWidget.height / 2);

                    //! update position with clamped values
                    ref.read(containerPositionProvider.notifier).state = Offset(
                      clampedX,
                      clampedY,
                    );
                  },
                  child: KeyboardWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
