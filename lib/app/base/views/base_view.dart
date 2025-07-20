import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => _buildMobileLayout(context),
        tablet: (BuildContext context) => _buildTabletLayout(context),
        desktop: (BuildContext context) => _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.desktop_windows_outlined,
                size: 48.0,
                color: AppColors.neutralWhite,
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Open on Desktop",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutralWhite,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                "This feature is only available on desktop devices for the best experience.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: AppColors.neutralWhite),
              ),
              // const SizedBox(height: 24.0),
              // ElevatedButton(
              //   onPressed: () {
              //     // Optional: Add action, e.g., navigate back or open a help page
              //     Navigator.of(context).pop();
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: AppColors.neutralWhite,
              //     padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8.0),
              //     ),
              //   ),
              //   child: const Text(
              //     "Go Back",
              //     style: TextStyle(
              //       fontSize: 16.0,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    final position = ref.watch(containerPositionProvider);
    final screenSize = MediaQuery.of(context).size;
    const double tabletKeyboardScale = 1.2;

    return SizedBox(
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
                  (KeyboardWidget.width * tabletKeyboardScale / 2),
              top:
                  position.dy +
                  (screenSize.height / 2) -
                  (KeyboardWidget.height * tabletKeyboardScale / 2),
              child: GestureDetector(
                onPanUpdate: (details) {
                  // Calculate new position
                  final newPosition = position + details.delta;

                  // Clamp position to screen boundaries
                  final clampedX =
                      (newPosition.dx +
                              (screenSize.width / 2) -
                              (KeyboardWidget.width * tabletKeyboardScale / 2))
                          .clamp(
                            0.0,
                            screenSize.width -
                                KeyboardWidget.width * tabletKeyboardScale,
                          ) -
                      (screenSize.width / 2) +
                      (KeyboardWidget.width * tabletKeyboardScale / 2);
                  final clampedY =
                      (newPosition.dy +
                              (screenSize.height / 2) -
                              (KeyboardWidget.height * tabletKeyboardScale / 2))
                          .clamp(
                            0.0,
                            screenSize.height -
                                KeyboardWidget.height * tabletKeyboardScale,
                          ) -
                      (screenSize.height / 2) +
                      (KeyboardWidget.height * tabletKeyboardScale / 2);

                  // Update position with clamped values
                  ref.read(containerPositionProvider.notifier).state = Offset(
                    clampedX,
                    clampedY,
                  );
                },
                child: Transform.scale(
                  scale: tabletKeyboardScale,
                  child: KeyboardWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final position = ref.watch(containerPositionProvider);
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
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
                  // Calculate new position
                  final newPosition = position + details.delta;

                  // Clamp position to screen boundaries
                  final clampedX =
                      (newPosition.dx +
                              (screenSize.width / 2) -
                              (KeyboardWidget.width / 2))
                          .clamp(0.0, screenSize.width - KeyboardWidget.width) -
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

                  // Update position with clamped values
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
    );
  }
}
