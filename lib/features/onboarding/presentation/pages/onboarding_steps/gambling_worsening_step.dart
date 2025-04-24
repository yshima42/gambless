import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../../domain/models/onboarding_model.dart';
import '../../widgets/onboarding_widgets.dart';

class GamblingWorseningStep extends ConsumerWidget {
  final VoidCallback onNext;

  const GamblingWorseningStep({super.key, required this.onNext});

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
            questionNumber: 'Question #4',
            question: 'Has your gambling habit been getting worse over time?',
            description:
                'This information helps us suggest the most appropriate recovery plan.',
            icon: Icons.trending_up,
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
                  Icons.psychology,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Psychological Perspective',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gambling disorders often show progressive symptoms, with behavior escalating over time. Recognizing this progression is the first step to recovery.',
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

          const SizedBox(height: 32),

          // Yes option
          OnboardingOptionCard(
            title: 'Yes, it has been getting worse',
            subtitle: 'The frequency or stakes have increased over time',
            isSelected: onboardingData.isGettingWorse == true,
            autoNavigate: true,
            onNext: onNext,
            onTap: () {
              onboardingNotifier.updateIsGettingWorse(true);
            },
          ),

          // No option
          OnboardingOptionCard(
            title: 'No, it has been stable',
            subtitle: 'There has been no significant change',
            isSelected: onboardingData.isGettingWorse == false,
            autoNavigate: true,
            onNext: onNext,
            onTap: () {
              onboardingNotifier.updateIsGettingWorse(false);
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
