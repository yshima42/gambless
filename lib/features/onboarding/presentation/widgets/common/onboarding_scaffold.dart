import 'package:flutter/material.dart';
import 'page_background.dart';

class OnboardingScaffold extends StatelessWidget {
  final Widget child;
  final bool hasScrollView;

  const OnboardingScaffold({
    super.key,
    required this.child,
    this.hasScrollView = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          const PageBackground(),

          // Content
          SafeArea(
            child: hasScrollView
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: child,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: child,
                  ),
          ),
        ],
      ),
    );
  }
}
