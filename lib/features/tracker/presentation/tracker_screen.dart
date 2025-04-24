import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const daysClean = 42;
    final milestones = [1, 7, 30, 90, 180, 365];
    final percentTo30 = (daysClean % 30) / 30;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
              children: [
                // Streak card (with milestones integrated)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 36, horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          'without gambling',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 160,
                              height: 160,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: percentTo30),
                                duration: const Duration(milliseconds: 1000),
                                builder: (context, value, _) {
                                  return CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 12,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    backgroundColor: Colors.grey.shade200,
                                    strokeCap: StrokeCap.round,
                                  );
                                },
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '$daysClean',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'days',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'You\'re doing great! Keep going!',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 24),

                        // Milestones row (integrated in the same card)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: milestones.map((days) {
                            final reached = daysClean >= days;
                            final isNext = !reached &&
                                (milestones.indexOf(days) == 0 ||
                                    milestones[milestones.indexOf(days) - 1] <
                                        daysClean);

                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: reached
                                        ? Theme.of(context).colorScheme.primary
                                        : isNext
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                    border: isNext
                                        ? Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Center(
                                    child: reached
                                        ? const Icon(
                                            Icons.emoji_events,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        : Text(
                                            '$days',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: isNext
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Colors.grey.shade500,
                                            ),
                                          ),
                                  ),
                                ),
                                if (isNext && daysClean > 0)
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      value: daysClean / days,
                                      strokeWidth: 2,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Milestone card removed, Calendar strip card is now next
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Tracking',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Day labels
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ...[
                                  'M',
                                  'T',
                                  'W',
                                  'T',
                                  'F',
                                  'S',
                                  'S'
                                ].map((day) => SizedBox(
                                      height: 22,
                                      width: 20,
                                      child: Center(
                                        child: Text(day,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ))
                              ],
                            ),
                            const SizedBox(width: 4),
                            // Heatmap grid
                            Expanded(
                              child: SizedBox(
                                height: 160,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 15,
                                  itemBuilder: (context, weekIndex) {
                                    return Column(
                                      children: List.generate(7, (dayIndex) {
                                        final hasSlipped =
                                            (weekIndex * 7 + dayIndex) % 9 == 0;
                                        final moodLevel = hasSlipped
                                            ? 0
                                            : ((weekIndex * 7 + dayIndex) %
                                                    11) ~/
                                                2;

                                        final color = hasSlipped
                                            ? Colors.red.shade100
                                            : moodLevel == 0
                                                ? Colors.grey.shade200
                                                : moodLevel == 1
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withValues(alpha: 0.15)
                                                    : moodLevel == 2
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withValues(
                                                                alpha: 0.4)
                                                        : moodLevel == 3
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                                .withValues(
                                                                    alpha: 0.7)
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .primary;

                                        return Container(
                                          margin: const EdgeInsets.all(1),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            border: hasSlipped
                                                ? Border.all(
                                                    color: Colors.red.shade300,
                                                    width: 1)
                                                : null,
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 4),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                border: Border.all(
                                    color: Colors.red.shade300, width: 1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const Text('Slip',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                            const SizedBox(width: 8),
                            const Text('Mood:',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                            const SizedBox(width: 4),
                            const Text('Bad',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                            const SizedBox(width: 4),
                            ...List.generate(5, (index) {
                              final color = index == 0
                                  ? Colors.grey.shade200
                                  : index == 1
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.15)
                                      : index == 2
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.4)
                                          : index == 3
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.7)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary;
                              return Container(
                                margin: const EdgeInsets.only(right: 2),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            }),
                            const SizedBox(width: 4),
                            const Text('Good',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 画面下部のボタンのためのスペースを追加（高さを小さくした）
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.pushNamed('settings'),
            ),
          ),
          // 浮かせたボタンを画面下部に固定（上に移動し、デザイン改良）
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      label: const Text('Log a Slip',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      style: FilledButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .error
                            .withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => context.pushNamed('chat'),
                      icon: const Icon(Icons.chat_bubble_outline, size: 20),
                      label: const Text('AI Chat',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      style: FilledButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
