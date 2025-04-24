import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/data/providers/onboarding_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // iOSの場合はバイブレーションを許可
  await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');

  runApp(
    const ProviderScope(
      child: GamblessApp(),
    ),
  );
}

class GamblessApp extends ConsumerWidget {
  const GamblessApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Gambless',
      theme: AppTheme.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            // デバッグボタン（右下に配置）
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                mini: true,
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

                  // オンボーディングページに移動
                  router.go('/onboarding');
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
