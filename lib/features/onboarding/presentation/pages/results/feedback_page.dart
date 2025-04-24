import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../onboarding_steps/testimonial_step.dart';
import '../onboarding_steps/reminder_settings_step.dart';

class FeedbackPage extends ConsumerWidget {
  final VoidCallback onComplete;

  const FeedbackPage({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF121212),
                  const Color(0xFF1E1E2E),
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Your feedback',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.feedback,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Introduction text
                    Text(
                      'How satisfied are you with the analysis?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Satisfaction rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildRatingButton(
                            context, Icons.sentiment_very_dissatisfied, 'Poor'),
                        _buildRatingButton(
                            context, Icons.sentiment_dissatisfied, 'Fair'),
                        _buildRatingButton(
                            context, Icons.sentiment_neutral, 'Good'),
                        _buildRatingButton(
                            context, Icons.sentiment_satisfied, 'Great'),
                        _buildRatingButton(context,
                            Icons.sentiment_very_satisfied, 'Excellent'),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Comments section
                    Text(
                      'Any additional comments?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Your thoughts on the assessment...',
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),

                    const SizedBox(height: 40),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          // ユーザーの声ページに遷移（オンボーディングをまだ完了しない）
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TestimonialStep(
                                onNext: () {
                                  // リマインダー設定ページに遷移
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ReminderSettingsStep(
                                        onNext: () {
                                          // すべてのステップが完了したらオンボーディングを完了
                                          onComplete();
                                          context.go('/');
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Continue to Testimonials',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingButton(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
