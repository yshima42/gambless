import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../widgets/onboarding_widgets.dart';

class AnalysisStep extends ConsumerWidget {
  final VoidCallback onNext;

  const AnalysisStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingPhaseNotifier = ref.read(onboardingPhaseProvider.notifier);

    // 次へ進む前に、フェーズを結果フェーズに変更
    void handleNext() {
      // フェーズを結果フェーズに変更
      onboardingPhaseNotifier.state = 2;
      onNext();
    }

    return OnboardingAnalysisIndicator(onNext: handleNext);
  }
}
