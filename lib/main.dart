import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'shared/widgets/buttons/debug_buttons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SupabaseのURLとアノニマスキーを環境変数から取得
  final url = const String.fromEnvironment('SUPABASE_URL');
  final anonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
    // ディープリンク認証のためのPKCE設定
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

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
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Gambless',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            // デバッグボタン（左側に配置）
            const DebugButtons(),
          ],
        );
      },
    );
  }
}
