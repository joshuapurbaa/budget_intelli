import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ContextExtensions on BuildContext {
  ColorScheme get color => Theme.of(this).colorScheme;
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

extension StringExtensions on String {
  String noSlashes() {
    return replaceAll('/', '');
  }
}

extension StringToDoubleParsing on String {
  /// Mengonversi string ke double dengan mempertimbangkan format
  /// internasional menggunakan NumberFormat dari paket intl.

  double toDoubleIntl(BuildContext context) {
    final languageVal = ControllerHelper.getLanguage(context);
    return NumberFormat.decimalPattern(languageVal).parse(this).toDouble();
  }
}

extension StringToDateTime on String {
  DateTime toDateTime() {
    return DateTime.parse(this);
  }
}
