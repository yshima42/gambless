import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../../domain/models/onboarding_model.dart';
import '../../widgets/onboarding_widgets.dart';

class GamblingFrequencyStep extends ConsumerWidget {
  final VoidCallback onNext;

  const GamblingFrequencyStep({super.key, required this.onNext});

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
            questionNumber: 'Question #2',
            question: 'How often do you gamble?',
            description:
                'Understanding your gambling habits helps us create a more effective program for you.',
            icon: Icons.timeline,
          ),
          const SizedBox(height: 32),

          // Scientific evidence container
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
                  Icons.science,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Research-Based Approach',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'University of California research shows that understanding gambling frequency enables more effective recovery programs.',
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
            children: GamblingFrequency.values.map((frequency) {
              final isSelected = onboardingData.gamblingFrequency == frequency;

              return OnboardingOptionCard(
                title: frequency.label,
                isSelected: isSelected,
                autoNavigate: true,
                onNext: onNext,
                onTap: () {
                  onboardingNotifier.updateGamblingFrequency(frequency);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
