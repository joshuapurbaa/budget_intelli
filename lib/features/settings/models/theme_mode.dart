import 'package:flutter/material.dart';

enum IntelliThemeMode {
  dark(
    ThemeMode.dark,
    'Dark Mode',
  ),

  light(
    ThemeMode.light,
    'Light Mode',
  ),

  system(
    ThemeMode.system,
    'System Mode',
  );

  const IntelliThemeMode(this.themeMode, this.name);
  final ThemeMode themeMode;
  final String name;
}
