import 'package:flutter/material.dart';

import '../../widgets/onboarding_widgets.dart';

class TestimonialStep extends StatelessWidget {
  final VoidCallback onNext;

  const TestimonialStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const QuizHeader(
                      questionNumber: 'Step #1',
                      question: 'Real Testimonials',
                      description:
                          'Here are stories from people who have recovered from gambling addiction. You are not alone.',
                      icon: Icons.groups,
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        const OnboardingTestimonial(
                          quote:
                              'Thanks to Gambless, I was able to overcome my 30-year gambling habit. Now I cherish time with my family and manage my finances well.',
                          author: 'John (58)',
                        ),
                        const SizedBox(height: 16),
                        const OnboardingTestimonial(
                          quote:
                              'I almost gave up many times, but the scientific approach and daily support of this app helped me break free from slot machine addiction.',
                          author: 'Michael (42)',
                        ),
                        const SizedBox(height: 16),
                        const OnboardingTestimonial(
                          quote:
                              'I accumulated a lot of debt from sports betting, but Gambless budget management features and cognitive behavioral therapy helped me pay off my debts and start a new life.',
                          author: 'David (29)',
                        ),
                        const SizedBox(height: 24),

                        // Success stats
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.verified,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Success Rate',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '78% of users who continued to use Gambless for more than 6 months succeeded in significantly improving or completely eliminating their gambling habits.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: onNext,
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            'Continue to Reminders',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
