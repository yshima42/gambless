import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/onboarding_model.dart';

class OnboardingNotifier extends StateNotifier<OnboardingData> {
  OnboardingNotifier() : super(OnboardingData());

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateAge(int age) {
    state = state.copyWith(age: age);
  }

  void updateGender(Gender gender) {
    state = state.copyWith(gender: gender);
  }

  void updateGamblingFrequency(GamblingFrequency frequency) {
    state = state.copyWith(gamblingFrequency: frequency);
  }

  void updateHowFoundApp(HowFoundApp howFound) {
    state = state.copyWith(howFoundApp: howFound);
  }

  void updateIsGettingWorse(bool isWorse) {
    state = state.copyWith(isGettingWorse: isWorse);
  }

  void updateGamblingStartTime(GamblingStartTime startTime) {
    state = state.copyWith(gamblingStartTime: startTime);
  }

  void toggleGamblingType(GamblingType type) {
    final List<GamblingType> updatedTypes = List.from(state.gamblingTypes);
    if (updatedTypes.contains(type)) {
      updatedTypes.remove(type);
    } else {
      updatedTypes.add(type);
    }
    state = state.copyWith(gamblingTypes: updatedTypes);
  }

  void toggleGamblingTrigger(GamblingTrigger trigger) {
    final List<GamblingTrigger> updatedTriggers =
        List.from(state.gamblingTriggers);
    if (updatedTriggers.contains(trigger)) {
      updatedTriggers.remove(trigger);
    } else {
      updatedTriggers.add(trigger);
    }
    state = state.copyWith(gamblingTriggers: updatedTriggers);
  }

  void toggleRecoveryGoal(RecoveryGoal goal) {
    final List<RecoveryGoal> updatedGoals = List.from(state.recoveryGoals);
    if (updatedGoals.contains(goal)) {
      updatedGoals.remove(goal);
    } else {
      updatedGoals.add(goal);
    }
    state = state.copyWith(recoveryGoals: updatedGoals);
  }

  void setDailyReminders(bool wantsDailyReminders) {
    state = state.copyWith(wantsDailyReminders: wantsDailyReminders);
  }

  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
  }

  void resetOnboarding() {
    state = OnboardingData();
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingData>((ref) {
  return OnboardingNotifier();
});

// 現在のオンボーディングステップを管理するプロバイダー
final onboardingStepProvider = StateProvider<int>((ref) => 0);

// オンボーディングの総ステップ数
final onboardingTotalStepsProvider = Provider<int>((ref) => 10);

// オンボーディングの質問部分のステップ数 (Question #1-#9)
final onboardingQuestionStepsProvider = Provider<int>((ref) => 9);

// オンボーディングが質問段階を完了しているかどうかを確認するプロバイダー
final isOnboardingQuestionsCompletedProvider = Provider<bool>((ref) {
  final currentStep = ref.watch(onboardingStepProvider);
  final questionSteps = ref.watch(onboardingQuestionStepsProvider);
  return currentStep > questionSteps;
});

// オンボーディングフェーズを管理するプロバイダー（0: 質問フェーズ、1: 分析中、2: 結果フェーズ）
final onboardingPhaseProvider = StateProvider<int>((ref) => 0);

// オンボーディングが完了しているかどうかを確認するプロバイダー
final isOnboardingCompletedProvider = Provider<bool>((ref) {
  return ref.watch(onboardingProvider).hasCompletedOnboarding;
});
