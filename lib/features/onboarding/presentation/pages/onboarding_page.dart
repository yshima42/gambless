import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers/onboarding_provider.dart';
import '../widgets/onboarding_widgets.dart' as widgets;
import 'onboarding_steps/welcome_step.dart';
import 'onboarding_steps/gender_step.dart';
import 'onboarding_steps/gambling_frequency_step.dart';
import 'onboarding_steps/gambling_types_step.dart';
import 'onboarding_steps/gambling_triggers_step.dart';
import 'onboarding_steps/recovery_goals_step.dart';
import 'onboarding_steps/personalization_step.dart';
import 'onboarding_steps/scientific_explanation_step.dart';
import 'onboarding_steps/testimonial_step.dart';
import 'onboarding_steps/reminder_settings_step.dart';
import 'onboarding_steps/subscription_step.dart';
import 'onboarding_steps/gambling_worsening_step.dart';
import 'onboarding_steps/gambling_start_time_step.dart';
import 'onboarding_steps/how_found_app_step.dart';
import 'onboarding_steps/analysis_step.dart';
import 'onboarding_steps/analysis_result_step.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(onboardingStepProvider);
    final totalSteps = ref.watch(onboardingTotalStepsProvider);
    final questionSteps = ref.watch(onboardingQuestionStepsProvider);
    final onboardingPhase = ref.watch(onboardingPhaseProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final onboardingStepNotifier = ref.read(onboardingStepProvider.notifier);
    final onboardingPhaseNotifier = ref.read(onboardingPhaseProvider.notifier);

    // ScrollController to control scrolling behavior
    final ScrollController scrollController = ScrollController();

    void goToNextStep() {
      if (currentStep < totalSteps) {
        // 質問フェーズが終了してフェーズが切り替わる場合
        if (currentStep == questionSteps && onboardingPhase == 0) {
          // 分析フェーズに移行
          onboardingPhaseNotifier.state = 1;
        }

        onboardingStepNotifier.state = currentStep + 1;

        // スクロールコントローラーが接続されている場合のみスクロールを実行
        if (scrollController.hasClients) {
          // Scroll to top when moving to next step
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      } else {
        // Complete onboarding
        onboardingNotifier.completeOnboarding();
        context.go('/');
      }
    }

    void goToPreviousStep() {
      if (currentStep > 0) {
        // 結果フェーズから分析フェーズに戻る場合、質問フェーズに戻す
        if (onboardingPhase == 2 && currentStep == (questionSteps + 1)) {
          onboardingPhaseNotifier.state = 0;
        }

        onboardingStepNotifier.state = currentStep - 1;

        // スクロールコントローラーが接続されている場合のみスクロールを実行
        if (scrollController.hasClients) {
          // Scroll to top when moving to previous step
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    }

    // Display the current step based on the step index and phase
    Widget buildCurrentStep() {
      // 分析フェーズの場合は分析インジケーターを表示
      if (onboardingPhase == 1) {
        return AnalysisStep(onNext: () {
          // 分析が完了したらオンボーディングも完了
          // オンボーディングページからの遷移は AnalysisStep 内で行われる
        });
      }

      switch (currentStep) {
        case 0:
          return WelcomeStep(onNext: goToNextStep);
        case 1:
          return GenderStep(onNext: goToNextStep);
        case 2:
          return GamblingFrequencyStep(onNext: goToNextStep);
        case 3:
          return HowFoundAppStep(onNext: goToNextStep);
        case 4:
          return GamblingStartTimeStep(onNext: goToNextStep);
        case 5:
          return GamblingWorseningStep(onNext: goToNextStep);
        case 6:
          return GamblingTypesStep(onNext: goToNextStep);
        case 7:
          return GamblingTriggersStep(onNext: goToNextStep);
        case 8:
          return RecoveryGoalsStep(onNext: goToNextStep);
        case 9:
          return PersonalizationStep(onNext: goToNextStep);
        case 10:
          // 分析結果ステップ (質問ステップ数 + 1)
          return AnalysisResultStep(onNext: goToNextStep);
        case 11:
          return ScientificExplanationStep(onNext: goToNextStep);
        case 12:
          return TestimonialStep(onNext: goToNextStep);
        case 13:
          return ReminderSettingsStep(onNext: goToNextStep);
        case 14:
          return SubscriptionStep(onNext: goToNextStep);
        default:
          return WelcomeStep(onNext: goToNextStep);
      }
    }

    // Create a gradient background with dark theme colors
    final gradientBackground = Container(
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
    );

    // 分析フェーズや結果表示ステップの間はプログレスバーを表示しない
    final bool showProgressBar =
        onboardingPhase != 1 && currentStep != (questionSteps + 1);

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          gradientBackground,

          // Safe area for content
          SafeArea(
            child: Column(
              children: [
                // Top bar with back button and progress
                if (currentStep > 0 && showProgressBar)
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        widgets.BackButton(onPressed: goToPreviousStep),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: widgets.OnboardingProgressBar(),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Main content area
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: buildCurrentStep(),
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
