import 'package:flutter/material.dart';

import '../../widgets/onboarding_widgets.dart';

class WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;

  const WelcomeStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.healing,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 40),
          Text(
            'Gambless',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your companion on the path to recovery from gambling addiction',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          const OnboardingTestimonial(
            quote:
                'This app changed my life. After 42 days without gambling, I finally feel truly free.',
            author: 'Ken Thompson',
          ),
          const SizedBox(height: 50),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: OnboardingButton(
                text: 'Start Quiz',
                onPressed: onNext,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              // For users with existing accounts, go to login page
              // For now, just proceed to main page
              onNext();
            },
            child: Text(
              'I already have an account',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
