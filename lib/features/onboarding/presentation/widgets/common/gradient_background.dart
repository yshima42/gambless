import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final darkColor1 = const Color(0xFF121212);
    final darkColor2 = const Color(0xFF1E1E2E);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                darkColor1,
                darkColor2,
                colorScheme.surface,
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
