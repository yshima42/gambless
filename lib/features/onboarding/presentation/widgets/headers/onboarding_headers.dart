import 'package:flutter/material.dart';

/// オンボーディングの標準ヘッダーウィジェット
class OnboardingHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;

  const OnboardingHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null)
          Icon(
            icon,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
        if (icon != null) const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// クイズのヘッダーウィジェット
class QuizHeader extends StatelessWidget {
  final String questionNumber;
  final String question;
  final String? description;
  final IconData? icon;

  const QuizHeader({
    super.key,
    required this.questionNumber,
    required this.question,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          questionNumber,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),

        // Question content
        if (icon != null)
          Icon(
            icon,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
        if (icon != null) const SizedBox(height: 16),
        Text(
          question,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
          textAlign: TextAlign.center,
        ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
