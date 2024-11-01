import 'package:flutter/material.dart';

List<BoxShadow>? appBoxShadows(
  BuildContext context,
) {
  if (Theme.of(context).brightness == Brightness.light) {
    return null;
  }
  return [
    BoxShadow(
      color: Theme.of(context).colorScheme.shadow,
      offset: const Offset(1, 1),
      blurRadius: 5,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      offset: const Offset(1, 1),
      blurRadius: 5,
      spreadRadius: 2,
    ),
  ];
}

Border? appBorder(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.light) {
    return Border.all(
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
  return null;
}
