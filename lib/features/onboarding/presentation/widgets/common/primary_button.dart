import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final disabledColor = primaryColor.withAlpha(77); // 0.3 * 255 = 76.5 ≈ 77

    // バイブレーション関数
    void vibrate() {
      try {
        Vibration.vibrate(duration: 15, amplitude: 180);
      } catch (e) {
        // バイブレーションに対応していない場合のエラーハンドリング
      }
    }

    final Widget button = FilledButton(
      onPressed: onPressed == null
          ? null
          : () {
              vibrate(); // タップ時にバイブレーション
              onPressed!();
            },
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        disabledBackgroundColor: disabledColor,
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
    );

    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: button,
          )
        : button;
  }
}
