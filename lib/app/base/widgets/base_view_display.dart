import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlcty/app/base/widgets/text_display.dart';
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
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCard('WPM', session.wpm.toInt().toString()),
                _StatCard('CPM', session.cpm.toInt().toString()),
                _StatCard('Letters', session.currentSubset.join(', ')),
              ],
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
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withAlpha(40),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
