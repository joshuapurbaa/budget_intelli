import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class AppBoxError extends StatelessWidget {
  const AppBoxError({
    required this.message,
    super.key,
    this.onPressed,
    this.height,
    this.width,
    this.margin,
  });
  final String message;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AppBoxChild(
        height: height,
        width: width,
        margin: margin ?? getEdgeInsetsAll(16),
        child: Center(
          child: Column(
            children: [
              AppText.error(
                text: message,
              ),
              const SizedBox(height: 8),
              if (onPressed != null)
                const AppText.reg12(
                  text: 'Tap to retry',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
