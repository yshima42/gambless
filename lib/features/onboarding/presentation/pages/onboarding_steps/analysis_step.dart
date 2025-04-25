import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/onboarding_widgets.dart';

class AnalysisStep extends ConsumerWidget {
  final VoidCallback onNext;

  const AnalysisStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // インジケーターのアニメーションが100%完了したときに自動的に次のステップに進む
    // アニメーションはOnboardingAnalysisIndicator内部で管理されており、
    // そこで完了時にonNextを呼び出す
    return OnboardingAnalysisIndicator(onNext: onNext);
  }
}
