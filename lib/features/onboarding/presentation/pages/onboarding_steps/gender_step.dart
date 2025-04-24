import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../../domain/models/onboarding_model.dart';
import '../../widgets/onboarding_widgets.dart';

class GenderStep extends ConsumerWidget {
  final VoidCallback onNext;

  const GenderStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingData = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    // バイブレーション関数
    void vibrate() {
      try {
        Vibration.vibrate(duration: 15, amplitude: 180);
      } catch (e) {
        // バイブレーションに対応していない場合のエラーハンドリング
      }
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const QuizHeader(
            questionNumber: 'Question #1',
            question: 'What is your gender?',
            description:
                'This information helps us suggest a recovery program that fits you best',
            icon: Icons.person,
          ),
          const SizedBox(height: 32),

          // Scientific evidence container - タップ可能に
          InkWell(
            onTap: () {
              vibrate(); // タップ時にバイブレーション
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
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
                          'Science-Based Approach',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Research shows that gambling behavior patterns and recovery methods can vary based on gender.',
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
          ),

          const SizedBox(height: 24),

          Column(
            children: Gender.values.map((gender) {
              final isSelected = onboardingData.gender == gender;

              return OnboardingOptionCard(
                title: gender.label,
                isSelected: isSelected,
                autoNavigate: true,
                onNext: onNext,
                onTap: () {
                  onboardingNotifier.updateGender(gender);
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
