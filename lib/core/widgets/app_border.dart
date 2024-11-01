import 'package:flutter/material.dart';

Border appBorder(BuildContext context) {
  return Border.all(
    color: Theme.of(context).colorScheme.outlineVariant,
  );
}
