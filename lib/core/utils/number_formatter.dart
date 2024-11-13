import 'package:budget_intelli/features/settings/controller/settings_bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatStringToMoney(
    BuildContext context,
    String value, {
    int? decimalDigits,
  }) {
    final currencyState = context.read<SettingBloc>().state;
    final currency = currencyState.currency;

    final cleanVal = value.replaceAll(RegExp('[^0-9.]'), '');

    // Pastikan nilai tidak kosong
    final parsedValue = double.tryParse(cleanVal) ?? 0.0;
    final decimalByModulus = parsedValue % 1 == 0 ? 0 : 2;
    final formatter = NumberFormat.currency(
      locale: currency.locale,
      symbol: '${currency.symbol} ',
      decimalDigits: decimalDigits ?? decimalByModulus,
    );

    // Pertahankan titik desimal dan hapus karakter non-numeric lainnya

    return formatter.format(parsedValue);
  }

  static String formatStringToMoneyNoSymbol(
    BuildContext context,
    String value, {
    int? decimalDigits,
  }) {
    final currencyState = context.read<SettingBloc>().state;
    final currency = currencyState.currency;
    // Pertahankan titik desimal dan hapus karakter non-numeric lainnya
    final cleanVal = value.replaceAll(RegExp('[^0-9.]'), '');

    // Pastikan nilai tidak kosong
    final parsedValue = double.tryParse(cleanVal) ?? 0.0;
    final decimalByModulus = parsedValue % 1 == 0 ? 0 : 2;

    final formatter = NumberFormat.currency(
      locale: currency.locale,
      symbol: '',
      decimalDigits: decimalDigits ?? decimalByModulus,
    );

    return formatter.format(parsedValue);
  }

  static String formatToMoneyInt(BuildContext context, int value) {
    final currencyState = context.read<SettingBloc>().state;
    final currency = currencyState.currency;
    final decimalByModulus = value % 1 == 0 ? 0 : 2;
    final formatter = NumberFormat.currency(
      locale: currency.locale,
      symbol: '${currency.symbol} ',
      decimalDigits: decimalByModulus,
    );

    return formatter.format(value);
  }

  // format to money from double value
  static String formatToMoneyDouble(
    BuildContext context,
    double value, {
    int? decimalDigits,
    bool isSymbol = true,
  }) {
    final currencyState = context.read<SettingBloc>().state;
    final currency = currencyState.currency;
    final decimalByModulus = value % 1 == 0 ? 0 : 2;

    final formatter = NumberFormat.currency(
      locale: currency.locale,
      symbol: isSymbol == true ? '${currency.symbol} ' : '',
      decimalDigits: decimalDigits ?? decimalByModulus,
    );

    return formatter.format(value);
  }

  static String formatToMoneyDoubleNoSymbol(
    BuildContext context,
    double value, {
    int? decimalDigits,
  }) {
    final currencyState = context.read<SettingBloc>().state;
    final currency = currencyState.currency;
    final decimalByModulus = value % 1 == 0 ? 0 : 2;
    final formatter = NumberFormat.currency(
      locale: currency.locale,
      symbol: '',
      decimalDigits: decimalDigits ?? decimalByModulus,
    );

    return formatter.format(value);
  }

  static String formatToMoneyIntNoSymbol(BuildContext context, int value) {
    final currencyState = context.read<SettingBloc>().state;
    final currency = currencyState.currency;
    final decimalByModulus = value % 1 == 0 ? 0 : 2;
    final formatter = NumberFormat.currency(
      locale: currency.locale,
      symbol: '',
      decimalDigits: decimalByModulus,
    );

    return formatter.format(value);
  }

  static String formatToMoneyIntNoCurrency(int value) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(value);
  }
}
