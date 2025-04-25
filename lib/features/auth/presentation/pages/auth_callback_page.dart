import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// OAuth認証後のコールバックを処理するページ
class AuthCallbackPage extends ConsumerStatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  ConsumerState<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends ConsumerState<AuthCallbackPage> {
  @override
  void initState() {
    super.initState();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    // 認証状態の変更を監視
    final client = Supabase.instance.client;
    client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        // サインイン成功時はホーム画面に遷移
        if (mounted) {
          context.go('/');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'ログイン処理中...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () {
                // ホームに戻る
                context.go('/');
              },
              child: const Text('ホームに戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
