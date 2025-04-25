import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/onboarding_model.dart';
import '../../domain/models/onboarding_steps.dart';

part 'onboarding_provider.g.dart';

@riverpod
class Onboarding extends _$Onboarding {
  @override
  OnboardingData build() {
    return OnboardingData();
  }

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

  void setReminderTime(TimeOfDay time) {
    state = state.copyWith(reminderTime: time);
  }

  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
  }

  void resetOnboarding() {
    state = OnboardingData();
  }
}

// 現在のオンボーディングステップを管理するプロバイダー
@riverpod
class OnboardingStep extends _$OnboardingStep {
  @override
  int build() {
    return 0;
  }

  void set(int step) {
    state = step;
  }

  void increment() {
    state++;
  }

  void decrement() {
    if (state > 0) {
      state--;
    }
  }
}

// オンボーディングの総ステップ数
@riverpod
int onboardingTotalSteps(Ref ref) {
  return OnboardingSteps.totalStepCount;
}

// オンボーディングの質問部分のステップ数
@riverpod
int onboardingQuestionSteps(Ref ref) {
  return OnboardingSteps.questionStepCount;
}

// オンボーディングが質問段階を完了しているかどうかを確認するプロバイダー
@riverpod
bool isOnboardingQuestionsCompleted(Ref ref) {
  final currentStep = ref.watch(onboardingStepProvider);
  final questionSteps = ref.watch(onboardingQuestionStepsProvider);
  return currentStep > questionSteps;
}

// オンボーディングフェーズを管理するプロバイダー（0: 質問フェーズ、1: 分析中、2: 結果フェーズ）
@riverpod
class OnboardingPhase extends _$OnboardingPhase {
  @override
  int build() {
    return 0;
  }

  void set(int phase) {
    state = phase;
  }
}

// オンボーディングが完了しているかどうかを確認するプロバイダー
@riverpod
bool isOnboardingCompleted(Ref ref) {
  return ref.watch(onboardingProvider).hasCompletedOnboarding;
}
