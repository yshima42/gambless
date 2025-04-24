import 'package:flutter/material.dart';

import '../../widgets/onboarding_widgets.dart';

class TestimonialStep extends StatelessWidget {
  final VoidCallback onNext;

  const TestimonialStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const QuizHeader(
            questionNumber: 'Question #11',
            question: '実際の体験談',
            description: '同じようにギャンブル依存症から立ち直った方々の体験談をご紹介します。あなたは一人ではありません。',
            icon: Icons.groups,
          ),
          const SizedBox(height: 32),
          Column(
            children: [
              const OnboardingTestimonial(
                quote:
                    'ギャンブレスのおかげで、30年間のギャンブル習慣を克服できました。今は家族との時間を大切にし、お金の管理もうまくいっています。',
                author: '田中さん（58歳）',
              ),
              const SizedBox(height: 16),
              const OnboardingTestimonial(
                quote:
                    '何度も諦めそうになりましたが、このアプリの科学的なアプローチと毎日のサポートのおかげで、パチンコ依存から抜け出すことができました。',
                author: '佐藤さん（42歳）',
              ),
              const SizedBox(height: 16),
              const OnboardingTestimonial(
                quote:
                    'スポーツベッティングで多額の負債を抱えましたが、ギャンブレスの予算管理機能と認知行動療法で借金を返済し、新しい生活を始められました。',
                author: '鈴木さん（29歳）',
              ),
              const SizedBox(height: 24),

              // Success stats
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
                      Icons.verified,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '成功率',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ギャンブレスを6ヶ月以上継続して使用したユーザーの78%が、ギャンブル習慣を大幅に改善、または完全に断ち切ることに成功しています。',
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
          const SizedBox(height: 32),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: OnboardingButton(
                text: '次へ進む',
                onPressed: onNext,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
