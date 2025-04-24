import 'package:flutter/material.dart';

import '../utils/vibration_util.dart';
import 'gradient_circle_painter.dart';

/// オンボーディングの分析進行状況インジケーター
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
        VibrationUtil.dialPattern(baseAmplitude);
      }
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 最後に強めのバイブレーションでフィードバック
        VibrationUtil.completionPattern();

        // アニメーションが完了したら次へ進む
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onNext();
        });
      }
    });

    // アニメーション開始
    _animationController.forward();
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

            // 進行状況の表示
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade900,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 円形プログレスインジケーター（グラデーション）
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: GradientCirclePainter(
                        progress: _progressAnimation.value,
                        colors: [
                          const Color(0xFF4CAF50).withOpacity(0.7), // ライトグリーン
                          const Color(0xFF2E7D32), // メインのグリーン
                          const Color(0xFF1B5E20), // ダークグリーン
                        ],
                        strokeWidth: 12.0,
                      ),
                    ),
                  ),
                  // パーセント表示
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_progressPercent%',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
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
