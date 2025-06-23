import 'package:budget_intelli/core/l10n/app_localizations.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ContextExtensions on BuildContext {
  ColorScheme get color => Theme.of(this).colorScheme;
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Add new extension for SettingBloc theme mode
  bool get isDarkModeSetting => watch<SettingBloc>().state.isDarkMode;

  // localizer
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  // currency
}

extension StringExtensions on String {
  String noSlashes() {
    return replaceAll('/', '');
  }
}

// extension StringToDoubleParsing on String {
//   /// Mengonversi string ke double dengan mempertimbangkan format
//   /// internasional menggunakan NumberFormat dari paket intl.

//   double toDoubleIntl(BuildContext context) {
//     final languageVal = ControllerHelper.getLanguage(context);
//     return NumberFormat.decimalPattern(languageVal).parse(this).toDouble();
//   }
// }

extension StringToDateTime on String {
  DateTime toDateTime() {
    return DateTime.parse(this);
  }
}

extension StringToDouble on String {
  double toDouble() {
    // Hapus spasi putih di awal dan akhir string
    var input = trim();

    // Hapus karakter yang tidak valid
    input = input.replaceAll(RegExp('[^0-9,.]'), '');

    // Jika string kosong setelah dibersihkan
    if (input.isEmpty) {
      throw const FormatException('Input kosong setelah dibersihkan');
    }

    // Deteksi apakah terdapat lebih dari satu tanda koma atau titik
    if (input.contains(',') && input.contains('.')) {
      // Jika koma digunakan sebagai desimal, ganti koma dengan titik dan hilangkan titik sebagai pemisah ribuan
      if (input.lastIndexOf(',') > input.lastIndexOf('.')) {
        input = input.replaceAll('.', '');
        input = input.replaceAll(',', '.');
      }
      // Jika titik digunakan sebagai desimal, hilangkan koma sebagai pemisah ribuan
      else {
        input = input.replaceAll(',', '');
      }
    } else if (input.contains(',')) {
      // Split by comma to analyze the parts
      final parts = input.split(',');

      // Check if this looks like thousand separators or decimal separator
      var isThousandSeparator = false;

      if (parts.length > 2) {
        // Multiple commas = definitely thousand separators
        isThousandSeparator = true;
      } else if (parts.length == 2) {
        // Single comma: check if it's likely a thousand separator or decimal
        // If the part after comma has exactly 3 digits, it's likely a thousand separator
        // If it has 1-2 digits, it's likely a decimal separator
        if (parts[1].length == 3) {
          isThousandSeparator = true;
        } else if (parts[1].length <= 2) {
          // This is a decimal separator
          isThousandSeparator = false;
        }
      }

      if (isThousandSeparator) {
        // Remove all commas (thousand separators)
        input = input.replaceAll(',', '');
      }
      // If it's a decimal separator, keep the comma and let double.parse handle it
      // But double.parse expects dot, so replace comma with dot
      else {
        input = input.replaceAll(',', '.');
      }
    } else if (input.contains('.')) {
      final parts = input.split('.');
      if (parts.length == 2 && (parts[1] == '0' || parts[1] == '00')) {
        return double.parse(parts[0]);
      } else {
        if (parts[1].length == 3) {
          return input.replaceAll('.', '').toDouble();
        }
      }
    }

    // Coba konversi string yang telah dibersihkan menjadi double
    try {
      return double.parse(input);
    } on Exception catch (_) {
      throw FormatException(
        'Input tidak valid untuk dikonversi ke double: $input',
      );
    }
  }
}
