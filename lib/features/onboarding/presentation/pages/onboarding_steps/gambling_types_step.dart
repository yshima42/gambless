import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../../domain/models/onboarding_model.dart';
import '../../widgets/onboarding_widgets.dart';

class GamblingTypesStep extends ConsumerWidget {
  final VoidCallback onNext;

  const GamblingTypesStep({super.key, required this.onNext});

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
            questionNumber: 'Question #5',
            question: 'どのようなギャンブルをしますか？',
            description: '最も頻繁に行うギャンブルの種類を選択してください。複数選択可能です。',
            icon: Icons.casino,
          ),
          const SizedBox(height: 32),

          Column(
            children: GamblingType.values.map((type) {
              final isSelected = onboardingData.gamblingTypes.contains(type);

              IconData getIconForType(GamblingType type) {
                switch (type) {
                  case GamblingType.casino:
                    return Icons.casino;
                  case GamblingType.lottery:
                    return Icons.confirmation_number;
                  case GamblingType.sportsBetting:
                    return Icons.sports_football;
                  case GamblingType.pachinko:
                    return Icons.grain;
                  case GamblingType.onlineGambling:
                    return Icons.computer;
                  case GamblingType.cardGames:
                    return Icons.style;
                  case GamblingType.stockTrading:
                    return Icons.show_chart;
                }
              }

              return OnboardingOptionCard(
                title: type.label,
                isSelected: isSelected,
                icon: getIconForType(type),
                onTap: () {
                  onboardingNotifier.toggleGamblingType(type);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Psychological insight
          if (onboardingData.gamblingTypes.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '心理学的見解',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '異なるタイプのギャンブルは異なる心理的メカニズムを活性化します。あなたの選択に基づいて、最も効果的な回復戦略を提案します。',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Continue button - only show when at least one option is selected
          onboardingData.gamblingTypes.isNotEmpty
              ? OnboardingButton(
                  text: '次へ進む',
                  onPressed: onNext,
                )
              : const SizedBox(height: 48), // Placeholder for button space

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
