import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../../domain/models/onboarding_model.dart';
import '../../widgets/onboarding_widgets.dart';

class GamblingStartTimeStep extends ConsumerWidget {
  final VoidCallback onNext;

  const GamblingStartTimeStep({super.key, required this.onNext});

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
            question: 'How long have you been gambling?',
            description:
                'Understanding the duration of your gambling habits helps us suggest appropriate countermeasures.',
            icon: Icons.access_time,
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
                        'Scientific perspective',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'The duration of your gambling habits is an important indicator in the recovery process. The longer the habit, the deeper it is rooted in the brain\'s reward system.',
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
            children: GamblingStartTime.values.map((startTime) {
              final isSelected = onboardingData.gamblingStartTime == startTime;

              return OnboardingOptionCard(
                title: startTime.label,
                isSelected: isSelected,
                autoNavigate: true,
                onNext: onNext,
                onTap: () {
                  onboardingNotifier.updateGamblingStartTime(startTime);
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
