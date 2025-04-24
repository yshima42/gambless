import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String? description;
  final IconData? icon;

  const SectionHeader({
    super.key,
    required this.stepNumber,
    required this.title,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final whiteColor = Colors.white;
    final whiteWithAlpha = whiteColor.withAlpha(179); // 0.7 * 255 = 178.5 ≈ 179

    return Column(
      children: [
        Text(
          stepNumber,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),

        // Title content
        if (icon != null)
          Icon(
            icon,
            size: 48,
            color: colorScheme.primary,
          ),
        if (icon != null) const SizedBox(height: 16),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
          textAlign: TextAlign.center,
        ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: whiteWithAlpha,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
