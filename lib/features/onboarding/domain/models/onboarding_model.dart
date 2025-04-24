import 'package:flutter/material.dart' show TimeOfDay;

class OnboardingData {
  final String name;
  final int age;
  final Gender? gender;
  final GamblingFrequency? gamblingFrequency;
  final HowFoundApp? howFoundApp;
  final bool? isGettingWorse;
  final GamblingStartTime? gamblingStartTime;
  final List<GamblingType> gamblingTypes;
  final List<GamblingTrigger> gamblingTriggers;
  final List<RecoveryGoal> recoveryGoals;
  final bool wantsDailyReminders;
  final TimeOfDay? reminderTime;
  final bool hasCompletedOnboarding;

  OnboardingData({
    this.name = '',
    this.age = 0,
    this.gender,
    this.gamblingFrequency,
    this.howFoundApp,
    this.isGettingWorse,
    this.gamblingStartTime,
    this.gamblingTypes = const [],
    this.gamblingTriggers = const [],
    this.recoveryGoals = const [],
    this.wantsDailyReminders = true,
    this.reminderTime,
    this.hasCompletedOnboarding = false,
  });

  OnboardingData copyWith({
    String? name,
    int? age,
    Gender? gender,
    GamblingFrequency? gamblingFrequency,
    HowFoundApp? howFoundApp,
    bool? isGettingWorse,
    GamblingStartTime? gamblingStartTime,
    List<GamblingType>? gamblingTypes,
    List<GamblingTrigger>? gamblingTriggers,
    List<RecoveryGoal>? recoveryGoals,
    bool? wantsDailyReminders,
    TimeOfDay? reminderTime,
    bool? hasCompletedOnboarding,
  }) {
    return OnboardingData(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      gamblingFrequency: gamblingFrequency ?? this.gamblingFrequency,
      howFoundApp: howFoundApp ?? this.howFoundApp,
      isGettingWorse: isGettingWorse ?? this.isGettingWorse,
      gamblingStartTime: gamblingStartTime ?? this.gamblingStartTime,
      gamblingTypes: gamblingTypes ?? this.gamblingTypes,
      gamblingTriggers: gamblingTriggers ?? this.gamblingTriggers,
      recoveryGoals: recoveryGoals ?? this.recoveryGoals,
      wantsDailyReminders: wantsDailyReminders ?? this.wantsDailyReminders,
      reminderTime: reminderTime ?? this.reminderTime,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}

enum Gender {
  male('Male'),
  female('Female'),
  other('Other'),
  notSpecified('Prefer not to say');

  final String label;
  const Gender(this.label);
}

enum GamblingFrequency {
  daily('Daily'),
  severalTimesWeek('Several times a week'),
  weekly('Weekly'),
  occasionally('Occasionally'),
  rarely('Rarely');

  final String label;
  const GamblingFrequency(this.label);
}

enum HowFoundApp {
  searchEngine('Search Engine'),
  socialMedia('Social Media'),
  friend('Friend Recommendation'),
  therapist('Therapist/Doctor Recommendation'),
  advertisement('Advertisement'),
  other('Other');

  final String label;
  const HowFoundApp(this.label);
}

enum GamblingStartTime {
  lessThanYear('Less than 1 year'),
  oneToThreeYears('1-3 years'),
  fourToFiveYears('4-5 years'),
  moreThanFiveYears('More than 5 years'),
  moreThanTenYears('More than 10 years');

  final String label;
  const GamblingStartTime(this.label);
}

enum GamblingType {
  casino('Casino'),
  lottery('Lottery'),
  sportsBetting('Sports Betting'),
  pachinko('Pachinko / Slots'),
  onlineGambling('Online Gambling'),
  cardGames('Card Games'),
  stockTrading('Speculative Trading');

  final String label;
  const GamblingType(this.label);
}

enum GamblingTrigger {
  stress('Stress'),
  boredom('Boredom'),
  socialPressure('Social Pressure'),
  financialProblems('Financial Problems'),
  depression('Depression'),
  excitement('Seeking Excitement'),
  escapism('Escapism');

  final String label;
  const GamblingTrigger(this.label);
}

enum RecoveryGoal {
  completeAbstinence('Complete Abstinence'),
  reducedFrequency('Reduced Frequency'),
  budgetControl('Budget Control'),
  timeManagement('Time Management'),
  healthierAlternatives('Find Healthier Alternatives'),
  supportNetwork('Build Support Network');

  final String label;
  const RecoveryGoal(this.label);
}
