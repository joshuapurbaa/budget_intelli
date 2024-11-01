import 'package:equatable/equatable.dart';

class CurrencyModel extends Equatable {
  const CurrencyModel({
    required this.name,
    required this.symbol,
    required this.code,
    required this.locale,
  });

  final String name;
  final String symbol;
  final String code;
  final String locale;

  // CurrencyModel initial
  static CurrencyModel initial = const CurrencyModel(
    name: 'Dollar',
    symbol: r'$',
    code: 'USD',
    locale: 'en_US',
  );

  @override
  List<Object?> get props => [name, symbol, code, locale];
}
