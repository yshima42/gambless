import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

import '../../data/providers/onboarding_provider.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const OnboardingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          // ボタン押下時にバイブレーション
          try {
            // より歯切れの良い短い単一振動
            Vibration.vibrate(duration: 15, amplitude: 180);
          } catch (e) {
            // バイブレーションに対応していない場合のエラーハンドリング
          }

          onPressed();
        },
        style: FilledButton.styleFrom(
          backgroundColor: isPrimary
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade800,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class OnboardingProgressBar extends ConsumerWidget {
  const OnboardingProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(onboardingStepProvider);
    final questionSteps = ref.watch(onboardingQuestionStepsProvider);

    // 現在のステップが質問ステップ数を超えている場合は、進捗を100%とする
    // そうでなければ、現在のステップ / 質問ステップ数（+1 for Analysis）として計算
    final progress = currentStep > questionSteps
        ? 1.0
        : (currentStep / (questionSteps + 1)).clamp(0.0, 1.0);

    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey.shade800,
      color: Theme.of(context).colorScheme.primary,
      minHeight: 4,
      borderRadius: BorderRadius.circular(2),
    );
  }
}

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

class OnboardingOptionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final bool autoNavigate;
  final VoidCallback? onNext;

  const OnboardingOptionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.autoNavigate = false,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () {
          // タップ時にバイブレーション
          try {
            // より歯切れの良い短い単一振動
            Vibration.vibrate(duration: 10, amplitude: 150);
          } catch (e) {
            // バイブレーションに対応していない場合のエラーハンドリング
          }

          onTap();
          // Auto-navigate to next step after selection if enabled
          if (autoNavigate && onNext != null) {
            Future.delayed(const Duration(milliseconds: 300), onNext);
          }
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white.withOpacity(0.7),
                  size: 24,
                ),
              if (icon != null) const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingTestimonial extends StatelessWidget {
  final String quote;
  final String author;

  const OnboardingTestimonial({
    super.key,
    required this.quote,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        children: [
          Text(
            quote,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '- $author',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: onPressed,
        color: Colors.white,
        style: IconButton.styleFrom(
          backgroundColor: Colors.black26,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}

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

class OnboardingAnalysisIndicator extends StatefulWidget {
  final VoidCallback onNext;

  const OnboardingAnalysisIndicator({
    super.key,
    required this.onNext,
  });

  @override
  State<OnboardingAnalysisIndicator> createState() =>
      _OnboardingAnalysisIndicatorState();
}

class _OnboardingAnalysisIndicatorState
    extends State<OnboardingAnalysisIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  int _progressPercent = 0;

  @override
  void initState() {
    super.initState();
    // 分析時間を5秒に短縮
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // 前回のバイブレーションタイミングを記録
    double lastVibrationValue = 0.0;

    _progressAnimation.addListener(() {
      setState(() {
        _progressPercent = (_progressAnimation.value * 100).round();
      });

      // ダイヤルを回す感覚のバイブレーション
      // 進行度が5%増えるごとにバイブレーション
      double currentValue = _progressAnimation.value;
      if (currentValue - lastVibrationValue >= 0.05) {
        lastVibrationValue = currentValue;

        // 進行度に応じて強度と間隔を調整
        int baseAmplitude = (currentValue * 200).round().clamp(40, 200);
        _vibrateWithDialPattern(baseAmplitude);
      }
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 最後に強めのバイブレーションでフィードバック
        _vibrateWithCompletionPattern();

        // アニメーションが完了したら次へ進む
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onNext();
        });
      }
    });

    // アニメーション開始
    _animationController.forward();
  }

  // ダイヤル回転感覚のバイブレーション機能
  void _vibrateWithDialPattern(int amplitude) {
    try {
      // 短いバイブレーションを3回連続で実行し、ダイヤルのカチカチ感を再現
      List<int> pattern = [
        0,
        20,
        30,
        20,
        30,
        20
      ]; // ミリ秒単位: [待機, 振動, 待機, 振動, 待機, 振動]
      List<int> intensities = [
        0,
        amplitude,
        0,
        amplitude,
        0,
        amplitude
      ]; // 強度: [0, 強度, 0, 強度, 0, 強度]

      Vibration.vibrate(pattern: pattern, intensities: intensities);
    } catch (e) {
      // バイブレーションに対応していない場合のエラーハンドリング
    }
  }

  // 完了時の特別なバイブレーションパターン
  void _vibrateWithCompletionPattern() {
    try {
      // 完了時は「ダイヤルがロックされた」感覚を再現
      List<int> pattern = [0, 40, 30, 80, 40, 120]; // [待機, 振動, 待機, 振動, 待機, 振動]
      List<int> intensities = [0, 120, 0, 160, 0, 200]; // 強度が徐々に上がる

      Vibration.vibrate(pattern: pattern, intensities: intensities);
    } catch (e) {
      // バイブレーションに対応していない場合のエラーハンドリング
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.psychology,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 40),

            // 進行状況の表示（角丸のグラデーションインジケーター）
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // 外側の円形コンテナ
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade900,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    // 進行状況インジケーター
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 160,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade800,
                            border: Border.all(
                              color: Colors.grey.shade700,
                              width: 1,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // プログレスバー
                              FractionallySizedBox(
                                widthFactor: _progressAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF4CAF50)
                                            .withOpacity(0.7), // ライトグリーン
                                        const Color(0xFF2E7D32), // メインのグリーン
                                        const Color(0xFF1B5E20), // ダークグリーン
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4CAF50)
                                            .withOpacity(0.5),
                                        blurRadius: 8,
                                        spreadRadius: -2,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '$_progressPercent%',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),
            Text(
              'Calculating Results',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Analyzing your responses to create a personalized program',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
