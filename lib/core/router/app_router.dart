import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/onboarding/data/providers/onboarding_provider.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/tracker/presentation/pages/tracker_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isOnboardingCompleted = ref.watch(isOnboardingCompletedProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // オンボーディングが完了していない場合は、オンボーディングページにリダイレクト
      if (!isOnboardingCompleted && state.fullPath != '/onboarding') {
        return '/onboarding';
      }

      // オンボーディングが完了している場合は、オンボーディングページにアクセスできないようにする
      if (isOnboardingCompleted && state.fullPath == '/onboarding') {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'tracker',
        builder: (context, _) => const TrackerPage(),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, _) => const ChatPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, _) => const SettingsPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, _) => const OnboardingPage(),
      ),
    ],
  );
});

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'tracker',
        builder: (context, _) => const TrackerPage(),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, _) => const ChatPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, _) => const SettingsPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, _) => const OnboardingPage(),
      ),
    ],
  );
}
