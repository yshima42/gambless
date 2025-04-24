import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers/onboarding_provider.dart';
import '../widgets/onboarding_widgets.dart' as widgets;
import 'onboarding_steps/welcome_step.dart';
import 'onboarding_steps/lets_go_step.dart';
import 'onboarding_steps/gender_step.dart';
import 'onboarding_steps/gambling_frequency_step.dart';
import 'onboarding_steps/how_found_app_step.dart';
import 'onboarding_steps/gambling_start_time_step.dart';
import 'onboarding_steps/gambling_worsening_step.dart';
import 'onboarding_steps/gambling_types_step.dart';
import 'onboarding_steps/gambling_triggers_step.dart';
import 'onboarding_steps/recovery_goals_step.dart';
import 'onboarding_steps/personalization_step.dart';
import 'onboarding_steps/analysis_step.dart';
import 'onboarding_steps/analysis_result_step.dart';
import 'onboarding_steps/scientific_explanation_step.dart';
import 'onboarding_steps/testimonial_step.dart';
import 'onboarding_steps/reminder_settings_step.dart';
import 'onboarding_steps/subscription_step.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  // 質問フェーズのステップをリスト化
  static final List<Widget Function(VoidCallback)> _questionSteps = [
    (onNext) => WelcomeStep(onNext: onNext),
    (onNext) => LetsGoStep(onNext: onNext),
    (onNext) => GenderStep(onNext: onNext),
    (onNext) => GamblingFrequencyStep(onNext: onNext),
    (onNext) => HowFoundAppStep(onNext: onNext),
    (onNext) => GamblingStartTimeStep(onNext: onNext),
    (onNext) => GamblingWorseningStep(onNext: onNext),
    (onNext) => GamblingTypesStep(onNext: onNext),
    (onNext) => GamblingTriggersStep(onNext: onNext),
    (onNext) => RecoveryGoalsStep(onNext: onNext),
    (onNext) => PersonalizationStep(onNext: onNext),
  ];

  // 質問フェーズ後のステップをリスト化
  static final List<Widget Function(VoidCallback)> _postQuestionSteps = [
    (onNext) => AnalysisResultStep(onNext: onNext),
    (onNext) => ScientificExplanationStep(onNext: onNext),
    (onNext) => TestimonialStep(onNext: onNext),
    (onNext) => ReminderSettingsStep(onNext: onNext),
    (onNext) => SubscriptionStep(onNext: onNext),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(onboardingStepProvider);
    final totalSteps = ref.watch(onboardingTotalStepsProvider);
    final questionStepsCount = ref.watch(onboardingQuestionStepsProvider);
    final onboardingPhase = ref.watch(onboardingPhaseProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final onboardingStepNotifier = ref.read(onboardingStepProvider.notifier);
    final onboardingPhaseNotifier = ref.read(onboardingPhaseProvider.notifier);
    final scrollController = ScrollController();

    void goToNextStep() {
      if (currentStep < totalSteps) {
        if (currentStep == questionStepsCount && onboardingPhase == 0) {
          onboardingPhaseNotifier.state = 1;
        }
        onboardingStepNotifier.state = currentStep + 1;
        if (scrollController.hasClients) {
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      } else {
        onboardingNotifier.completeOnboarding();
        context.go('/');
      }
    }

    void goToPreviousStep() {
      if (currentStep > 0) {
        if (onboardingPhase == 2 && currentStep == questionStepsCount + 1) {
          onboardingPhaseNotifier.state = 0;
        }
        onboardingStepNotifier.state = currentStep - 1;
        if (scrollController.hasClients) {
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      }
    }

    Widget buildCurrentStep() {
      // 分析フェーズ中は AnalysisStep を表示
      if (onboardingPhase == 1) {
        return AnalysisStep(onNext: () {});
      }

      // 質問フェーズ
      if (currentStep < questionStepsCount && onboardingPhase == 0) {
        return _questionSteps[currentStep](goToNextStep);
      }

      // 質問後フェーズ
      final postIndex = onboardingPhase == 0
          ? currentStep - questionStepsCount
          : currentStep - questionStepsCount - 1;
      if (postIndex >= 0 && postIndex < _postQuestionSteps.length) {
        return _postQuestionSteps[postIndex](goToNextStep);
      }

      // フォールバック
      return WelcomeStep(onNext: goToNextStep);
    }

    final gradientBackground = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF121212),
            const Color(0xFF1E1E2E),
            Theme.of(context).colorScheme.surface
          ],
        ),
      ),
    );

    final showProgressBar = onboardingPhase != 1 &&
        currentStep > 1 && // Welcome と LetsGo の後から
        currentStep < questionStepsCount + 1; // 質問フェーズの間のみ

    // 質問の進捗を計算（Welcome と LetsGo を除外）
    final questionProgress = currentStep > 1
        ? (currentStep - 2) /
            (questionStepsCount - 2) // -2 は Welcome と LetsGo を除外
        : 0.0;

    return Scaffold(
      body: Stack(
        children: [
          gradientBackground,
          SafeArea(
            child: Column(
              children: [
                if (showProgressBar)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          BackButton(onPressed: goToPreviousStep),
                          const SizedBox(width: 16),
                          Expanded(
                            child: widgets.OnboardingProgressBar(
                              progress: questionProgress,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: buildCurrentStep(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
