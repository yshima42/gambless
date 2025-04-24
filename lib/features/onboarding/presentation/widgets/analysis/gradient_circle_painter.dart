import 'package:flutter/material.dart';

/// グラデーションサークルを描画するためのカスタムペインター
class GradientCirclePainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final double strokeWidth;

  GradientCirclePainter({
    required this.progress,
    required this.colors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 進行が0の場合は何も描画しない
    if (progress == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // グラデーションの設定 (12時の位置から開始するように修正)
    final gradient = SweepGradient(
      colors: colors,
      startAngle: -1.5708, // -90度 (12時の位置)
      endAngle: 4.7124, // 270度
      tileMode: TileMode.clamp,
      stops: const [0.0, 0.5, 1.0], // 均一なグラデーション配分
    );

    // グラデーションを適用するためのペイント
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    // 進行度に基づいて円弧を描画
    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // 上部から開始（-90度）
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant GradientCirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.colors != colors ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
