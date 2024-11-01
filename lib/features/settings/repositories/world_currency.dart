import 'package:budget_intelli/features/settings/settings_barrel.dart';

class WorldCurrency {
  WorldCurrency._();

  static final currencyList = [
    const CurrencyModel(
      name: 'Dollar',
      symbol: r'$',
      code: 'USD',
      locale: 'en_US',
    ),
    const CurrencyModel(
      name: 'Rupiah',
      symbol: 'Rp',
      code: 'IDR',
      locale: 'id_ID',
    ),
    const CurrencyModel(
      name: 'Euro',
      symbol: '€',
      code: 'EUR',
      locale: 'en_US',
    ),
    const CurrencyModel(
      name: 'Yen',
      symbol: '¥',
      code: 'JPY',
      locale: 'ja_JP',
    ),
    const CurrencyModel(
      name: 'Yuan',
      symbol: '¥',
      code: 'CNY',
      locale: 'zh_CN',
    ),
    const CurrencyModel(
      name: 'Won',
      symbol: '₩',
      code: 'KRW',
      locale: 'ko_KR',
    ),
    const CurrencyModel(
      name: 'Pound',
      symbol: '£',
      code: 'GBP',
      locale: 'en_GB',
    ),
    const CurrencyModel(
      name: 'Rupee',
      symbol: '₹',
      code: 'INR',
      locale: 'hi_IN',
    ),
    const CurrencyModel(
      name: 'Ruble',
      symbol: '₽',
      code: 'RUB',
      locale: 'ru_RU',
    ),
    const CurrencyModel(
      name: 'Franc',
      symbol: '₣',
      code: 'CHF',
      locale: 'fr_CH',
    ),
    const CurrencyModel(
      name: 'Ringgit',
      symbol: 'RM',
      code: 'MYR',
      locale: 'ms_MY',
    ),
    const CurrencyModel(
      name: 'Baht',
      symbol: '฿',
      code: 'THB',
      locale: 'th_TH',
    ),
    const CurrencyModel(
      name: 'Peso',
      symbol: '₱',
      code: 'PHP',
      locale: 'fil_PH',
    ),
    const CurrencyModel(
      name: 'Dong',
      symbol: '₫',
      code: 'VND',
      locale: 'vi_VN',
    ),
    const CurrencyModel(
      name: 'Real',
      symbol: r'R$',
      code: 'BRL',
      locale: 'pt',
    ),
    const CurrencyModel(
      name: 'Lira',
      symbol: '₺',
      code: 'TRY',
      locale: 'tr_TR',
    ),
  ];
}
