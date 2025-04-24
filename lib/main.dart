import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gambless/features/chat/presentation/chat_screen.dart';
import 'package:gambless/features/settings/presentation/settings_screen.dart';
import 'package:gambless/features/tracker/presentation/tracker_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const ProviderScope(child: GamblessApp()));

class GamblessApp extends ConsumerWidget {
  const GamblessApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = _router;
    return MaterialApp.router(
      title: 'Gambless',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF006E6D),
        textTheme: GoogleFonts.nunitoTextTheme(),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}

/*────────────────────────────── ROUTER ──────────────────────────────*/
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'tracker',
      builder: (context, _) => const TrackerScreen(),
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, _) => const ChatScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, _) => const SettingsScreen(),
    ),
  ],
);
