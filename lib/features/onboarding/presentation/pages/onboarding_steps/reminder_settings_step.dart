import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../widgets/onboarding_widgets.dart';

class ReminderSettingsStep extends ConsumerWidget {
  final VoidCallback onNext;

  const ReminderSettingsStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingData = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const QuizHeader(
            questionNumber: 'Question #12',
            question: 'リマインダー設定',
            description: '定期的なリマインダーは、回復の継続に効果的です。毎日のリマインダーを受け取りますか？',
            icon: Icons.notifications_active,
          ),
          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '習慣形成のために',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '毎日同じ時間にリマインダーを受け取ることで、回復のための新しい習慣を形成しやすくなります。',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Daily reminder toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: onboardingData.wantsDailyReminders
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor,
                width: onboardingData.wantsDailyReminders ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications,
                  color: onboardingData.wantsDailyReminders
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white.withOpacity(0.7),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '毎日のリマインダー',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: onboardingData.wantsDailyReminders
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                        ),
                      ),
                      Text(
                        'エクササイズや課題のリマインドを毎日受け取る',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: onboardingData.wantsDailyReminders,
                  onChanged: (value) {
                    onboardingNotifier.setDailyReminders(value);
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Best practice for time selection
          if (onboardingData.wantsDailyReminders)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ベストプラクティス',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '研究によると、朝（起きてから1時間以内）または夜（寝る1時間前）にリマインダーを設定すると、最も効果的です。',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          Center(
            child: SizedBox(
              width: double.infinity,
              child: OnboardingButton(
                text: '次へ進む',
                onPressed: onNext,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
