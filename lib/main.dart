import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .envファイルを読み込む
  await dotenv.load(fileName: 'env/.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const ProviderScope(child: GamblessApp()));
}

class GamblessApp extends ConsumerWidget {
  const GamblessApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRouter.router;

    return MaterialApp.router(
      title: 'Gambless',
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
