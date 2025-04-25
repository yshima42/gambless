import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers/onboarding_provider.dart';
import '../../domain/models/onboarding_steps.dart';
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

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingPage> createState() =>
      _RefactoredOnboardingPageState();
}

class _RefactoredOnboardingPageState extends ConsumerState<OnboardingPage> {
  // すべてのオンボーディングステップの定義
  late final List<OnboardingStepDefinition> _steps;

  // 現在のステップインデックス
  int _currentStepIndex = 0;

  // スクロールコントローラー
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // OnboardingStepsからすべてのステップを取得
    _steps = OnboardingSteps.allSteps;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 次のステップに進む
  void _goToNextStep() {
    setState(() {
      final currentStep = _steps[_currentStepIndex];

      // 現在のステップが質問フェーズの最後なら、分析フェーズに移行
      if (currentStep.phase == OnboardingPhaseType.questions &&
          _isLastStepInPhase(
              _currentStepIndex, OnboardingPhaseType.questions)) {
        _currentStepIndex =
            _findFirstStepIndexInPhase(OnboardingPhaseType.analysis);
      }
      // 現在のステップが分析フェーズなら、結果フェーズに移行
      else if (currentStep.phase == OnboardingPhaseType.analysis) {
        _currentStepIndex =
            _findFirstStepIndexInPhase(OnboardingPhaseType.results);
      }
      // それ以外は単に次のステップへ
      else if (_currentStepIndex < _steps.length - 1) {
        _currentStepIndex++;
      }
      // 最後のステップなら、オンボーディング完了
      else {
        _completeOnboarding();
        return;
      }

      // スクロールを先頭に戻す
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 前のステップに戻る
  void _goToPreviousStep() {
    setState(() {
      final currentStep = _steps[_currentStepIndex];

      // 結果フェーズの最初のステップなら、分析フェーズに戻る
      if (currentStep.phase == OnboardingPhaseType.results &&
          _isFirstStepInPhase(_currentStepIndex, OnboardingPhaseType.results)) {
        _currentStepIndex =
            _findFirstStepIndexInPhase(OnboardingPhaseType.analysis);
      }
      // 分析フェーズの最初のステップなら、質問フェーズの最後に戻る
      else if (currentStep.phase == OnboardingPhaseType.analysis &&
          _isFirstStepInPhase(
              _currentStepIndex, OnboardingPhaseType.analysis)) {
        _currentStepIndex =
            _findLastStepIndexInPhase(OnboardingPhaseType.questions);
      }
      // それ以外は単に前のステップへ
      else if (_currentStepIndex > 0) {
        _currentStepIndex--;
      }

      // スクロールを先頭に戻す
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // オンボーディングを完了する
  void _completeOnboarding() {
    ref.read(onboardingProvider.notifier).completeOnboarding();
    context.goNamed('tracker');
  }

  // 特定のフェーズの最初のステップのインデックスを返す
  int _findFirstStepIndexInPhase(OnboardingPhaseType phase) {
    return _steps.indexWhere((step) => step.phase == phase);
  }

  // 特定のフェーズの最後のステップのインデックスを返す
  int _findLastStepIndexInPhase(OnboardingPhaseType phase) {
    int lastIndex = -1;
    for (int i = 0; i < _steps.length; i++) {
      if (_steps[i].phase == phase) {
        lastIndex = i;
      }
    }
    return lastIndex;
  }

  // 特定のインデックスのステップが、そのフェーズの最初のステップかどうかを返す
  bool _isFirstStepInPhase(int index, OnboardingPhaseType phase) {
    if (index <= 0 || _steps[index].phase != phase) return false;
    return _steps[index - 1].phase != phase;
  }

  // 特定のインデックスのステップが、そのフェーズの最後のステップかどうかを返す
  bool _isLastStepInPhase(int index, OnboardingPhaseType phase) {
    if (index >= _steps.length - 1 || _steps[index].phase != phase)
      return false;
    return _steps[index + 1].phase != phase;
  }

  // 質問フェーズのステップ数（Welcome, LetsGoを除く）を取得
  int get _questionStepsWithoutIntro {
    return _steps
        .where((step) =>
            step.phase == OnboardingPhaseType.questions &&
            step.id != 'welcome' &&
            step.id != 'lets_go')
        .length;
  }

  // 質問フェーズの進捗（Welcome, LetsGoを除く）を計算
  double get _questionProgress {
    if (_steps[_currentStepIndex].phase != OnboardingPhaseType.questions ||
        _currentStepIndex <= 1) {
      return 0.0;
    }

    // Welcome, LetsGoを除いた現在の進捗位置
    final currentProgress = _currentStepIndex - 2;

    return currentProgress / _questionStepsWithoutIntro;
  }

  @override
  Widget build(BuildContext context) {
    // プログレスバーを表示するかどうか
    final showProgressBar =
        _steps[_currentStepIndex].phase == OnboardingPhaseType.questions &&
            _currentStepIndex > 1;

    // 背景のグラデーション
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

    return Scaffold(
      body: Stack(
        children: [
          gradientBackground,
          SafeArea(
            child: Column(
              children: [
                // プログレスバー
                if (showProgressBar)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          BackButton(onPressed: _goToPreviousStep),
                          const SizedBox(width: 16),
                          Expanded(
                            child: widgets.OnboardingProgressBar(
                              progress: _questionProgress,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // 現在のステップを表示
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: _steps[_currentStepIndex].builder(_goToNextStep),
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
