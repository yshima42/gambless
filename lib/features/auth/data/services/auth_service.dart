import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final Supabase _supabase = Supabase.instance;
  final Logger _logger = Logger();

  // Supabaseクライアントを取得
  SupabaseClient get client => _supabase.client;

  // 現在のユーザーセッションを取得
  Session? get currentSession => client.auth.currentSession;

  // 現在のユーザーを取得
  User? get currentUser => client.auth.currentUser;

  // ユーザーがログインしているかを確認
  bool get isAuthenticated => currentUser != null;

  // GoogleでSign In
  Future<void> signInWithGoogle() async {
    try {
      final redirectUrl = kIsWeb ? null : 'io.gambless.app://login-callback/';

      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: redirectUrl,
      );
    } catch (error) {
      _logger.e('Google sign in failed: $error');
      rethrow;
    }
  }

  // AppleでSign In
  Future<void> signInWithApple() async {
    try {
      final redirectUrl = kIsWeb ? null : 'io.gambless.app://login-callback/';

      await client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: redirectUrl,
      );
    } catch (error) {
      _logger.e('Apple sign in failed: $error');
      rethrow;
    }
  }

  // サインアウト
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (error) {
      _logger.e('Sign out failed: $error');
      rethrow;
    }
  }
}
