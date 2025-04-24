import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../../domain/models/onboarding_model.dart';
import '../../widgets/onboarding_widgets.dart';

class RecoveryGoalsStep extends ConsumerWidget {
  final VoidCallback onNext;

  const RecoveryGoalsStep({super.key, required this.onNext});

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
            questionNumber: 'Question #8',
            question: 'What are your recovery goals?',
            description:
                'Select all that apply. Having clear goals helps track your progress.',
            icon: Icons.flag,
          ),
          const SizedBox(height: 24),

          // 成功率に関する情報
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
                  Icons.bar_chart,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '成功率',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '明確な目標を設定したユーザーは、目標がないユーザーに比べて76%高い成功率を示しています。',
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
            children: RecoveryGoal.values.map((goal) {
              final isSelected = onboardingData.recoveryGoals.contains(goal);

              IconData getIconForGoal(RecoveryGoal goal) {
                switch (goal) {
                  case RecoveryGoal.completeAbstinence:
                    return Icons.block;
                  case RecoveryGoal.reducedFrequency:
                    return Icons.trending_down;
                  case RecoveryGoal.budgetControl:
                    return Icons.account_balance_wallet;
                  case RecoveryGoal.timeManagement:
                    return Icons.access_time;
                  case RecoveryGoal.healthierAlternatives:
                    return Icons.swap_horiz;
                  case RecoveryGoal.supportNetwork:
                    return Icons.group;
                }
              }

              String getSubtitleForGoal(RecoveryGoal goal) {
                switch (goal) {
                  case RecoveryGoal.completeAbstinence:
                    return 'ギャンブルを完全にやめる';
                  case RecoveryGoal.reducedFrequency:
                    return 'ギャンブルの頻度を減らす';
                  case RecoveryGoal.budgetControl:
                    return '予算内で管理する';
                  case RecoveryGoal.timeManagement:
                    return 'ギャンブルに費やす時間を制限する';
                  case RecoveryGoal.healthierAlternatives:
                    return '他の活動でギャンブルを置き換える';
                  case RecoveryGoal.supportNetwork:
                    return '周囲からのサポートを得る';
                }
              }

              return OnboardingOptionCard(
                title: goal.label,
                subtitle: getSubtitleForGoal(goal),
                isSelected: isSelected,
                icon: getIconForGoal(goal),
                onTap: () {
                  onboardingNotifier.toggleRecoveryGoal(goal);
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
