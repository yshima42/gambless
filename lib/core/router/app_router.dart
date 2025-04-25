import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/pages/auth_callback_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/onboarding/data/providers/onboarding_provider.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/tracker/presentation/pages/tracker_page.dart';
import '../../features/welcome/presentation/pages/welcome_page.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final isOnboardingCompleted = ref.watch(isOnboardingCompletedProvider);

  return GoRouter(
    // オンボーディングが完了していればトラッカーページ、そうでなければウェルカムページから開始
    initialLocation: isOnboardingCompleted ? '/' : '/welcome',
    redirect: (context, state) {
      // ウェルカムページはオンボーディング完了前のみアクセス可能
      if (state.fullPath == '/welcome' && isOnboardingCompleted) {
        return '/';
      }

      // オンボーディングが完了していない場合は、オンボーディングページにリダイレクト
      // ただし、チャットページへのアクセスは許可
      if (!isOnboardingCompleted &&
          state.fullPath != '/onboarding' &&
          state.fullPath != '/welcome' &&
          state.fullPath != '/chat' &&
          state.fullPath != '/auth/callback') {
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
        path: '/welcome',
        name: 'welcome',
        builder: (context, _) => const WelcomePage(),
      ),
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
      // Supabase認証コールバック用のルート
      GoRoute(
        path: '/auth/callback',
        name: 'auth_callback',
        builder: (context, _) => const AuthCallbackPage(),
      ),
    ],
  );
}

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/welcome',
    // ルーターのリダイレクトロジックを無効化（デバッグ用）
    // リダイレクトなしでオンボーディングページにアクセスできるようにする
    routes: [
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, _) => const WelcomePage(),
      ),
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
      // Supabase認証コールバック用のルート
      GoRoute(
        path: '/auth/callback',
        name: 'auth_callback',
        builder: (context, _) => const AuthCallbackPage(),
      ),
    ],
  );
}
