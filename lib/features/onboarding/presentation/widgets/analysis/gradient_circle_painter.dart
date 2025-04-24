import 'package:flutter/material.dart';

/// 単色のサークルを描画するためのカスタムペインター
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
    if (progress == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = colors.first; // 最初の色だけを使用

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // 12時方向からスタート
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
