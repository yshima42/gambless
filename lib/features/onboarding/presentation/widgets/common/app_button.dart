import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget button = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );

    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: button,
          )
        : button;
  }
}
