import 'package:flutter/material.dart';

import '../../widgets/onboarding_widgets.dart';

class ScientificExplanationStep extends StatelessWidget {
  final VoidCallback onNext;

  const ScientificExplanationStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const QuizHeader(
            questionNumber: 'Question #10',
            question: 'ギャンブル依存症のメカニズム',
            description:
                'ギャンブレスの回復方法は科学的根拠に基づいています。ギャンブル依存症のメカニズムを理解することが回復の第一歩です。',
            icon: Icons.psychology,
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              // 脳の報酬系の説明
              _buildScienceCard(
                context: context,
                title: '脳の報酬系',
                description:
                    'ギャンブルは脳の報酬系を刺激し、ドーパミンの放出を促します。これにより一時的な快感を得ますが、長期的には脳の報酬系が変化し、より強い刺激を求めるようになります。',
                iconData: Icons.psychology,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 16),

              // 習慣形成の説明
              _buildScienceCard(
                context: context,
                title: '習慣形成のサイクル',
                description:
                    'ギャンブル依存症は「きっかけ → 行動 → 報酬」のサイクルで形成されます。このサイクルを断ち切るためには、新しい健全な習慣を形成することが重要です。',
                iconData: Icons.loop,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 16),

              // 認知行動療法の説明
              _buildScienceCard(
                context: context,
                title: '認知行動療法',
                description:
                    'ギャンブレスのアプローチは認知行動療法に基づいています。これにより、ギャンブルに関する誤った信念を修正し、健全な対処メカニズムを開発します。',
                iconData: Icons.psychology_alt,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 16),

              // 研究結果
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
                      Icons.analytics,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '研究結果',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '最新の臨床研究によると、認知行動療法と習慣トラッキングを組み合わせたアプローチは、ギャンブル依存症の回復に87%の有効性を示しています。',
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

  Widget _buildScienceCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData iconData,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: color,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
