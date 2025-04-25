import 'package:flutter/material.dart';

import '../../presentation/pages/onboarding_steps/welcome_step.dart';
import '../../presentation/pages/onboarding_steps/lets_go_step.dart';
import '../../presentation/pages/onboarding_steps/gender_step.dart';
import '../../presentation/pages/onboarding_steps/gambling_frequency_step.dart';
import '../../presentation/pages/onboarding_steps/how_found_app_step.dart';
import '../../presentation/pages/onboarding_steps/gambling_start_time_step.dart';
import '../../presentation/pages/onboarding_steps/gambling_worsening_step.dart';
import '../../presentation/pages/onboarding_steps/gambling_types_step.dart';
import '../../presentation/pages/onboarding_steps/gambling_triggers_step.dart';
import '../../presentation/pages/onboarding_steps/recovery_goals_step.dart';
import '../../presentation/pages/onboarding_steps/personalization_step.dart';
import '../../presentation/pages/onboarding_steps/analysis_step.dart';
import '../../presentation/pages/onboarding_steps/analysis_result_step.dart';
import '../../presentation/pages/onboarding_steps/scientific_explanation_step.dart';
import '../../presentation/pages/onboarding_steps/testimonial_step.dart';
import '../../presentation/pages/onboarding_steps/reminder_settings_step.dart';
import '../../presentation/pages/onboarding_steps/subscription_step.dart';

/// オンボーディングのフェーズを表す列挙型
enum OnboardingPhaseType {
  questions, // 質問フェーズ
  analysis, // 分析フェーズ
  results, // 結果フェーズ
}

/// オンボーディングステップの定義
class OnboardingStepDefinition {
  final String id;
  final String name;
  final OnboardingPhaseType phase;
  final Widget Function(VoidCallback) builder;

  const OnboardingStepDefinition({
    required this.id,
    required this.name,
    required this.phase,
    required this.builder,
  });
}

/// すべてのオンボーディングステップの定義
class OnboardingSteps {
  // 質問フェーズのステップ
  static final List<OnboardingStepDefinition> questionSteps = [
    OnboardingStepDefinition(
      id: 'welcome',
      name: 'Welcome',
      phase: OnboardingPhaseType.questions,
      builder: (onNext) => WelcomeStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'lets_go',
      name: 'Let\'s Go',
      phase: OnboardingPhaseType.questions,
      builder: (onNext) => LetsGoStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'gender',
      name: 'Gender',
      phase: OnboardingPhaseType.questions,
      builder: (onNext) => GenderStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'gambling_frequency',
      name: 'Gambling Frequency',
      phase: OnboardingPhaseType.questions,
      builder: (onNext) => GamblingFrequencyStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'how_found_app',
      name: 'How Found App',
      phase: OnboardingPhaseType.questions,
      builder: (onNext) => HowFoundAppStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'gambling_start_time',
      name: 'Gambling Start Time',
      phase: OnboardingPhaseType.questions,
      builder: (onNext) => GamblingStartTimeStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'gambling_worsening',
      name: 'Gambling Worsening',
      phase: OnboardingPhaseType.questions,
      builder: (onNext) => GamblingWorseningStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'gambling_types',
      name: 'Gambling Types',
      phase: OnboardingPhaseType.questions,
      builder: (onNext) => GamblingTypesStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'gambling_triggers',
      name: 'Gambling Triggers',
      phase: OnboardingPhaseType.questions,
      builder: (onNext) => GamblingTriggersStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'recovery_goals',
      name: 'Recovery Goals',
      phase: OnboardingPhaseType.questions,
      builder: (onNext) => RecoveryGoalsStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'personalization',
      name: 'Personalization',
      phase: OnboardingPhaseType.questions,
      builder: (onNext) => PersonalizationStep(onNext: onNext),
    ),
  ];

  // 分析フェーズのステップ
  static final List<OnboardingStepDefinition> analysisSteps = [
    OnboardingStepDefinition(
      id: 'analysis',
      name: 'Analysis',
      phase: OnboardingPhaseType.analysis,
      builder: (onNext) => AnalysisStep(onNext: onNext),
    ),
  ];

  // 結果フェーズのステップ
  static final List<OnboardingStepDefinition> resultSteps = [
    OnboardingStepDefinition(
      id: 'analysis_result',
      name: 'Analysis Result',
      phase: OnboardingPhaseType.results,
      builder: (onNext) => AnalysisResultStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'scientific_explanation',
      name: 'Scientific Explanation',
      phase: OnboardingPhaseType.results,
      builder: (onNext) => ScientificExplanationStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'testimonial',
      name: 'Testimonial',
      phase: OnboardingPhaseType.results,
      builder: (onNext) => TestimonialStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'reminder_settings',
      name: 'Reminder Settings',
      phase: OnboardingPhaseType.results,
      builder: (onNext) => ReminderSettingsStep(onNext: onNext),
    ),
    OnboardingStepDefinition(
      id: 'subscription',
      name: 'Subscription',
      phase: OnboardingPhaseType.results,
      builder: (onNext) => SubscriptionStep(onNext: onNext),
    ),
  ];

  // すべてのステップを連結したリスト
  static List<OnboardingStepDefinition> get allSteps {
    return [...questionSteps, ...analysisSteps, ...resultSteps];
  }

  // 質問フェーズのステップ数を返す
  static int get questionStepCount => questionSteps.length;

  // 分析フェーズのステップ数を返す
  static int get analysisStepCount => analysisSteps.length;

  // 結果フェーズのステップ数を返す
  static int get resultStepCount => resultSteps.length;

  // 総ステップ数を返す
  static int get totalStepCount => allSteps.length;

  // 特定のフェーズのステップのみを返す
  static List<OnboardingStepDefinition> getStepsByPhase(
      OnboardingPhaseType phase) {
    return allSteps.where((step) => step.phase == phase).toList();
  }

  // フェーズの最初のステップインデックスを返す
  static int getFirstStepIndexForPhase(OnboardingPhaseType phase) {
    return allSteps.indexWhere((step) => step.phase == phase);
  }

  // フェーズの最後のステップインデックスを返す
  static int getLastStepIndexForPhase(OnboardingPhaseType phase) {
    int lastIndex = -1;
    for (int i = 0; i < allSteps.length; i++) {
      if (allSteps[i].phase == phase) {
        lastIndex = i;
      }
    }
    return lastIndex;
  }
}
