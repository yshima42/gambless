import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/notifiers/onboarding_notifier.dart';
import '../widgets/common/gradient_background.dart';
import '../widgets/common/section_header.dart';
import '../widgets/feedback/rating_button.dart';
import '../widgets/common/primary_button.dart';

class FeedbackPage extends StatefulWidget {
  final Function() onNext;

  const FeedbackPage({
    super.key,
    required this.onNext,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int? _selectedRating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  stepNumber: 'Step 3',
                  title: 'Your Feedback',
                  description: 'How satisfied are you with the analysis?',
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RatingButton(
                      icon: Icons.sentiment_very_dissatisfied,
                      label: 'Poor',
                      isSelected: _selectedRating == 1,
                      onPressed: () => _selectRating(1),
                    ),
                    RatingButton(
                      icon: Icons.sentiment_dissatisfied,
                      label: 'Fair',
                      isSelected: _selectedRating == 2,
                      onPressed: () => _selectRating(2),
                    ),
                    RatingButton(
                      icon: Icons.sentiment_neutral,
                      label: 'Good',
                      isSelected: _selectedRating == 3,
                      onPressed: () => _selectRating(3),
                    ),
                    RatingButton(
                      icon: Icons.sentiment_satisfied,
                      label: 'Great',
                      isSelected: _selectedRating == 4,
                      onPressed: () => _selectRating(4),
                    ),
                    RatingButton(
                      icon: Icons.sentiment_very_satisfied,
                      label: 'Excellent',
                      isSelected: _selectedRating == 5,
                      onPressed: () => _selectRating(5),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: PrimaryButton(
                    text: 'Continue',
                    onPressed: _selectedRating != null
                        ? () {
                            // 評価結果を保存
                            final notifier = Provider.of<OnboardingNotifier>(
                                context,
                                listen: false);
                            notifier.setFeedbackRating(_selectedRating!);

                            widget.onNext();
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectRating(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }
}
