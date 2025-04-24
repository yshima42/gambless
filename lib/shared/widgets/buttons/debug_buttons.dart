import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../features/onboarding/data/providers/onboarding_provider.dart';
import 'theme_toggle_button.dart';

class DebugButtons extends ConsumerWidget {
  const DebugButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return Positioned(
      left: 16,
      top: 0,
      bottom: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AIチャットボタン
            FloatingActionButton(
              mini: true,
              heroTag: 'ai_chat',
              backgroundColor: Colors.black45,
              onPressed: () {
                // オンボーディングが完了していない場合は完了状態にする
                final isOnboardingCompleted =
                    ref.read(isOnboardingCompletedProvider);
                if (!isOnboardingCompleted) {
                  final onboardingNotifier =
                      ref.read(onboardingProvider.notifier);
                  onboardingNotifier.completeOnboarding();
                }
                // チャットページに遷移（名前付きルートを使用）
                router.goNamed('chat');
              },
              child: const Icon(
                Icons.chat_outlined,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // テーマ切り替えボタン
            FloatingActionButton(
              mini: true,
              heroTag: 'theme',
              backgroundColor: Colors.black45,
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
                HapticFeedback.mediumImpact();
              },
              child: const ThemeToggleButton(),
            ),
            const SizedBox(height: 8),
            // デバッグボタン
            FloatingActionButton(
              mini: true,
              heroTag: 'debug',
              backgroundColor: Colors.black45,
              child: const Icon(Icons.bug_report, color: Colors.white),
              onPressed: () {
                // オンボーディングをリセットしてオンボーディングページに移動
                final onboardingNotifier =
                    ref.read(onboardingProvider.notifier);
                final onboardingStepNotifier =
                    ref.read(onboardingStepProvider.notifier);
                final onboardingPhaseNotifier =
                    ref.read(onboardingPhaseProvider.notifier);

                // オンボーディングの状態をリセット
                onboardingNotifier.resetOnboarding();
                onboardingStepNotifier.state = 0;
                onboardingPhaseNotifier.state = 0;

                // オンボーディングページに移動（名前付きルートを使用）
                router.goNamed('onboarding');
              },
            ),
          ],
        ),
      ),
    );
  }
}
