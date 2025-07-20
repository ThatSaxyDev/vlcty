import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlcty/app/base/widgets/text_display.dart';
import 'package:vlcty/app/typing/engine/adaptive_algorithm.dart';
import 'package:vlcty/app/typing/models/letter_stats.dart';
import 'package:vlcty/app/typing/notifiers/typing_session_notifier.dart';
import 'package:vlcty/theme/app_colors.dart';

class BaseViewDisplay extends ConsumerStatefulWidget {
  const BaseViewDisplay({super.key});

  @override
  ConsumerState<BaseViewDisplay> createState() => _BaseViewDisplayState();
}

class _BaseViewDisplayState extends ConsumerState<BaseViewDisplay> {
  @override
  Widget build(BuildContext context) {
    final session = ref.watch(typingSessionProvider);
    final notifier = ref.read(typingSessionProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: Colors.white.withAlpha(120),
        title: const Text('VLCTY'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.startNewLesson(),
          ),
          IconButton(
            icon: const Icon(Icons.settings_backup_restore),
            onPressed: () => notifier.resetProgress(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
           SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 900,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Metrics: ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Speed: ',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${session.wpm.toStringAsFixed(2)}wpm',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withAlpha(100),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Keys: ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ...List.generate(letterProgression.length, (index) {
                        return Container(
                          height: 25,
                          width: 25,
                          margin: EdgeInsets.only(right: 1),
                          decoration: BoxDecoration(
                            color:
                                session.currentSubset.contains(
                                  letterProgression[index],
                                )
                                ? ref
                                      .read(typingSessionProvider.notifier)
                                      .getIndicatorColor(
                                        letterProgression[index],
                                      )
                                : Colors.grey.withAlpha(30),
                          ),
                          child: Center(
                            child: Text(
                              letterProgression[index].toUpperCase(),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Target key: ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      if (session.targetLetter != null)
                        Container(
                          height: 25,
                          width: 25,
                          margin: EdgeInsets.only(right: 1),
                          decoration: BoxDecoration(
                            color: ref
                                .read(typingSessionProvider.notifier)
                                .getIndicatorColor(session.targetLetter!),
                          ),
                          child: Center(
                            child: Text(
                              session.targetLetter!.toUpperCase(),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Text Display
          TextDisplay(),

          // const SizedBox(height: 20),

          // const SizedBox(height: 20),

          // // Progress indicators
          // if (session.letterStats.isNotEmpty)
          //   Expanded(child: _LetterStatsDisplay(stats: session.letterStats)),
        ],
      ),
    );
  }
}

class _LetterStatsDisplay extends StatelessWidget {
  final Map<String, LetterStats> stats;

  const _LetterStatsDisplay({required this.stats});

  @override
  Widget build(BuildContext context) {
    final sortedEntries = stats.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Letter Performance',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: sortedEntries.length,
            itemBuilder: (context, index) {
              final entry = sortedEntries[index];
              final letter = entry.key;
              final stat = entry.value;

              final timeColor = stat.averageTime > 300
                  ? Colors.red
                  : stat.averageTime > 200
                  ? Colors.orange
                  : Colors.green;
              final accuracyColor = stat.accuracy < 0.8
                  ? Colors.red
                  : stat.accuracy < 0.9
                  ? Colors.orange
                  : Colors.green;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        letter.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${stat.averageTime.toInt()}ms',
                        style: TextStyle(fontSize: 10, color: timeColor),
                      ),
                      Text(
                        '${(stat.accuracy * 100).toInt()}%',
                        style: TextStyle(fontSize: 10, color: accuracyColor),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
