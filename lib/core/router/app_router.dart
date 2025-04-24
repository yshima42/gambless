import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/tracker/presentation/pages/tracker_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

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
    ],
  );
}
