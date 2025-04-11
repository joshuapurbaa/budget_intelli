import 'package:flutter/material.dart';

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

    // Bersihkan karakter yang tidak valid
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
      // Jika hanya ada koma, tetapi dibelakang terdapat 2 digit desimal, maka koma digunakan sebagai desimal
      final parts = input.split(',');
      if (parts.length == 2 && parts[1].length == 2) {
        return double.parse(input);
      } else {
        // Jika hanya ada koma, tetapi dibelakang terdapat 3 angka maka hilangkan koma
        if (parts[1].length == 3) {
          return double.parse(parts[0] + parts[1]);
        }
      }
    } else if (input.contains('.')) {
      final parts = input.split('.');
      if (parts.length == 2 && parts[1] == '0' || parts[1] == '00') {
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
    } catch (e) {
      throw FormatException(
        'Input tidak valid untuk dikonversi ke double: $input',
      );
    }
  }
}
