import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerWidget {
  final VoidCallback onComplete;

  const SignupPage({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF121212),
                  const Color(0xFF1E1E2E),
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'アカウントを作成',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'サインアップして、あなた専用の回復プログラムを開始しましょう',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),

                  // Social login buttons
                  _SocialSignInButton(
                    text: 'Googleでサインアップ',
                    icon: 'assets/images/google_logo.png',
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    onPressed: () => _signInWithGoogle(context),
                  ),
                  const SizedBox(height: 16),
                  _SocialSignInButton(
                    text: 'Appleでサインアップ',
                    icon: 'assets/images/apple_logo.png',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () => _signInWithApple(context),
                  ),
                  const SizedBox(height: 40),

                  // Skip for now option
                  TextButton(
                    onPressed: () {
                      // Skip account creation for now
                      onComplete();
                      context.pop();
                    },
                    child: Text(
                      'あとでサインアップ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              color: Colors.white,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black26,
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ダミー実装: 実際の実装ではFirebaseAuthの設定が必要
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // デモ目的で単純なディレイを入れる
      await Future.delayed(const Duration(seconds: 1));
      onComplete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google サインインに失敗しました: $e')),
      );
    }
  }

  // ダミー実装: 実際の実装ではFirebaseAuthの設定が必要
  Future<void> _signInWithApple(BuildContext context) async {
    try {
      // デモ目的で単純なディレイを入れる
      await Future.delayed(const Duration(seconds: 1));
      onComplete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Apple サインインに失敗しました: $e')),
      );
    }
  }
}

class _SocialSignInButton extends StatelessWidget {
  final String text;
  final String icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _SocialSignInButton({
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // アイコンはダミーなので、代わりにマテリアルアイコンを使用
            Icon(
              text.contains('Google') ? Icons.golf_course : Icons.apple,
              size: 24,
              color: textColor,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
