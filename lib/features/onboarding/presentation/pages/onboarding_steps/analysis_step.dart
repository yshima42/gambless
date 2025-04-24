import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../widgets/onboarding_widgets.dart';
import '../results/results_page.dart';

class AnalysisStep extends ConsumerWidget {
  final VoidCallback onNext;

  const AnalysisStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final onboardingPhaseNotifier = ref.read(onboardingPhaseProvider.notifier);

    // 分析が完了したら結果ページに遷移
    void handleNext() {
      // 分析完了後は結果ページに遷移（オンボーディングは完了しない）
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultsPage(onComplete: () {
            // 結果表示が完了したらオンボーディングを完了としてマーク
            onboardingNotifier.completeOnboarding();
          }),
        ),
      );
    }

    return OnboardingAnalysisIndicator(onNext: handleNext);
  }
}
