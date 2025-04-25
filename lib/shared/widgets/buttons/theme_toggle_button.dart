import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider.notifier);
    final isDark = themeNotifier.isDarkMode;

    return Icon(
      isDark ? Icons.light_mode : Icons.dark_mode,
      color: Colors.white,
      key: ValueKey<bool>(isDark),
    );
  }
}
