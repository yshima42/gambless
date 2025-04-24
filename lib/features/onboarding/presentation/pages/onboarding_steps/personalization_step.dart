import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../widgets/onboarding_widgets.dart';

class PersonalizationStep extends ConsumerWidget {
  final VoidCallback onNext;

  const PersonalizationStep({super.key, required this.onNext});

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
            questionNumber: 'Question #8',
            question: 'あなたについて教えてください',
            description: '回復プログラムをカスタマイズするために、いくつか詳細情報が必要です。',
            icon: Icons.person,
          ),
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'お名前（またはニックネーム）',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => onboardingNotifier.updateName(value),
                decoration: InputDecoration(
                  hintText: '例: 田中',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),
              Text(
                '年齢',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: onboardingData.age == 0 ? null : onboardingData.age,
                    hint: Text('年齢を選択',
                        style: TextStyle(color: Colors.white.withOpacity(0.6))),
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    isExpanded: true,
                    items: [
                      for (int i = 18; i <= 80; i++)
                        DropdownMenuItem(
                          value: i,
                          child: Text(
                            '$i',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        onboardingNotifier.updateAge(value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
                      Icons.auto_awesome,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'パーソナライズされたプログラム',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'あなたの情報に基づいて最適な回復プランを作成します。年齢やギャンブル習慣に合わせたアドバイスと戦略をご提供します。',
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
            ],
          ),
          const SizedBox(height: 24),
          // Continue button - only enabled when both name and age are provided
          Center(
            child: SizedBox(
              width: double.infinity,
              child: OnboardingButton(
                text: '次へ進む',
                onPressed:
                    onboardingData.name.isNotEmpty && onboardingData.age > 0
                        ? onNext
                        : () {},
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
