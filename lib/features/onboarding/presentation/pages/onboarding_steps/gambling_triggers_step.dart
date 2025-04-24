import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../../domain/models/onboarding_model.dart';
import '../../widgets/onboarding_widgets.dart';

class GamblingTriggersStep extends ConsumerWidget {
  final VoidCallback onNext;

  const GamblingTriggersStep({super.key, required this.onNext});

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
            questionNumber: 'Question #6',
            question: 'ギャンブルのきっかけ',
            description:
                'どのような状況でギャンブルをしたくなりますか？あなたの引き金となる要因を理解することは、回復への重要なステップです。',
            icon: Icons.warning_amber,
          ),
          const SizedBox(height: 32),

          // 専門家の意見
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
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '専門家の意見',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '「ギャンブルの引き金を特定し、それに対する対策を立てることで、再発リスクを大幅に減少させることができます。」- 日本依存症学会',
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

          Column(
            children: GamblingTrigger.values.map((trigger) {
              final isSelected =
                  onboardingData.gamblingTriggers.contains(trigger);

              IconData getIconForTrigger(GamblingTrigger trigger) {
                switch (trigger) {
                  case GamblingTrigger.stress:
                    return Icons.spa;
                  case GamblingTrigger.boredom:
                    return Icons.schedule;
                  case GamblingTrigger.socialPressure:
                    return Icons.people;
                  case GamblingTrigger.financialProblems:
                    return Icons.attach_money;
                  case GamblingTrigger.depression:
                    return Icons.sentiment_dissatisfied;
                  case GamblingTrigger.excitement:
                    return Icons.flash_on;
                  case GamblingTrigger.escapism:
                    return Icons.exit_to_app;
                }
              }

              return OnboardingOptionCard(
                title: trigger.label,
                isSelected: isSelected,
                icon: getIconForTrigger(trigger),
                onTap: () {
                  onboardingNotifier.toggleGamblingTrigger(trigger);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Continue button
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
