import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/settings/controller/settings_bloc/settings_bloc.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyFormatter {
  static CurrencyTextInputFormatter currencyFormatter(
    BuildContext context, {
    int? decimalDigits,
  }) {
    final locale = context.l10n.localeName;

    final currency = context.read<SettingBloc>().state.currency;
    return CurrencyTextInputFormatter.currency(
      locale: locale,
      symbol: currency.symbol,
      decimalDigits: decimalDigits ?? 0,
    );
  }
}
