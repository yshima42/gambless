import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/services/auth_service.dart';

// 認証サービスプロバイダー
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// 現在のユーザープロバイダー
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.client.auth.onAuthStateChange
      .map((event) => event.session?.user);
});

// 認証状態プロバイダー
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.isAuthenticated;
});
