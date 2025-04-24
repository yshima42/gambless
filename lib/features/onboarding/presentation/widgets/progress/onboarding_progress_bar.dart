import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/onboarding_provider.dart';

/// オンボーディングの進行状況を表示するプログレスバー
class OnboardingProgressBar extends ConsumerWidget {
  const OnboardingProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(onboardingStepProvider);
    final questionSteps = ref.watch(onboardingQuestionStepsProvider);

    // 現在のステップが質問ステップ数を超えている場合は、進捗を100%とする
    // そうでなければ、現在のステップ / 質問ステップ数（+1 for Analysis）として計算
    final progress = currentStep > questionSteps
        ? 1.0
        : (currentStep / (questionSteps + 1)).clamp(0.0, 1.0);

    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey.shade800,
      color: Theme.of(context).colorScheme.primary,
      minHeight: 4,
      borderRadius: BorderRadius.circular(2),
    );
  }
}
