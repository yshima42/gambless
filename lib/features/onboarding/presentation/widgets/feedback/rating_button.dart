import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class RatingButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const RatingButton({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final whiteColor = Colors.white;
    final selectedBackgroundColor =
        primaryColor.withAlpha(51); // 0.2 * 255 = 51

    // バイブレーション関数
    void vibrate() {
      try {
        Vibration.vibrate(duration: 15, amplitude: 180);
      } catch (e) {
        // バイブレーションに対応していない場合のエラーハンドリング
      }
    }

    return Column(
      children: [
        IconButton(
          onPressed: () {
            vibrate(); // タップ時にバイブレーション
            onPressed();
          },
          icon: Icon(
            icon,
            color: isSelected ? primaryColor : whiteColor,
            size: 32,
          ),
          style: IconButton.styleFrom(
            backgroundColor:
                isSelected ? selectedBackgroundColor : colorScheme.surface,
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryColor : whiteColor,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
