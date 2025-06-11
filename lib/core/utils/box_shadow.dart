import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

BoxShadow appBoxShadow(BuildContext context) {
  return BoxShadow(
    color: context.color.shadow.withValues(alpha: 0.1),
    blurRadius: 10,
    spreadRadius: 0.1,
    offset: const Offset(0, 1),
  );
}
