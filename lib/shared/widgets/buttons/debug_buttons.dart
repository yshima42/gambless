import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/theme_provider.dart' as theme_provider;
import '../../../features/onboarding/data/providers/onboarding_provider.dart';
import 'theme_toggle_button.dart';

class DebugButtons extends ConsumerWidget {
  const DebugButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ボタンの背景色をモードに応じて調整
    final buttonColor = isDark ? Colors.black45 : Colors.white.withOpacity(0.7);
    // アイコンの色をモードに応じて調整
    final iconColor = isDark ? Colors.white : theme.colorScheme.primary;

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
              backgroundColor: buttonColor,
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
                router.pushNamed('chat');
              },
              child: Icon(
                Icons.chat_outlined,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 8),
            // テーマ切り替えボタン
            FloatingActionButton(
              mini: true,
              heroTag: 'theme',
              backgroundColor: buttonColor,
              onPressed: () {
                ref.read(theme_provider.themeProvider.notifier).toggleTheme();
                HapticFeedback.mediumImpact();
              },
              child: const ThemeToggleButton(),
            ),
            const SizedBox(height: 8),
            // デバッグボタン
            FloatingActionButton(
              mini: true,
              heroTag: 'debug',
              backgroundColor: buttonColor,
              child: Icon(Icons.bug_report, color: iconColor),
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
