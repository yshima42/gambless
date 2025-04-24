import 'package:flutter/foundation.dart';

class OnboardingNotifier extends ChangeNotifier {
  int _feedbackRating = 0;

  int get feedbackRating => _feedbackRating;

  void setFeedbackRating(int rating) {
    _feedbackRating = rating;
    notifyListeners();
  }
}
