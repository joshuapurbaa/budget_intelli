import 'dart:io';

import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class BottomSheetParent extends StatelessWidget {
  const BottomSheetParent({
    required this.isWithBorderTop,
    required this.child,
    super.key,
  });

  final bool isWithBorderTop;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry? padding;

    if (Platform.isIOS) {
      padding = getEdgeInsets(
        left: 16,
        right: 16,
        top: 16,
        bottom: 24,
      );
    } else {
      padding = getEdgeInsets(
        left: 16,
        right: 16,
        bottom: 16,
        top: 16,
      );
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: isWithBorderTop
            ? Border(
                top: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withOpacity(0.5),
                ),
              )
            : null,
      ),
      child: child,
    );
  }
}
