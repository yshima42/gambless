import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../../domain/models/onboarding_model.dart';
import '../../widgets/onboarding_widgets.dart';

class HowFoundAppStep extends ConsumerWidget {
  final VoidCallback onNext;

  const HowFoundAppStep({super.key, required this.onNext});

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
            questionNumber: 'Question #3',
            question: 'How did you find this app?',
            description:
                'This information helps us reach more people who need our services.',
            icon: Icons.search,
          ),
          const SizedBox(height: 32),

          // Thank you message
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
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thank you for your cooperation',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your response will help us support others facing the same challenges.',
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
            children: HowFoundApp.values.map((howFound) {
              final isSelected = onboardingData.howFoundApp == howFound;

              return OnboardingOptionCard(
                title: howFound.label,
                isSelected: isSelected,
                autoNavigate: true,
                onNext: onNext,
                onTap: () {
                  onboardingNotifier.updateHowFoundApp(howFound);
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
