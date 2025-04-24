import 'package:flutter/material.dart';

/// オンボーディングの進行状況を表示するプログレスバー
class OnboardingProgressBar extends StatelessWidget {
  final double progress;

  const OnboardingProgressBar({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress.clamp(0.0, 1.0),
      backgroundColor: Colors.grey.shade800,
      color: Theme.of(context).colorScheme.primary,
      minHeight: 4,
      borderRadius: BorderRadius.circular(2),
    );
  }
}
