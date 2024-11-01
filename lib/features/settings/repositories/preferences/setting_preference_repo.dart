import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class SettingPreferenceRepo {
  static const String _themeMode = 'themeMode';
  static const String _currency = 'currency';
  static const String _language = 'language';
  static const String _initialSetting = 'initialSetting';
  static const String _intialCreateBudget = 'intialCreateBudget';
  static const String _onlyFinancialTracker = 'onlyFinancialTracker';
  static const String _useBiometrics = 'biometrics';
  static const String _isAuthenticated = 'authenticated';
  static const String _authTimestamp = 'authTimestamp';
  static const String _notificationEnable = 'notificationEnable';
  static const String _schedulePaymentNotification =
      'schedulePaymentNotification';

  static const Duration _sessionDuration = Duration(minutes: 30);

  // Setters and Getters for initial create budget
  Future<void> setIntialCreateBudget({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_intialCreateBudget, value);
  }

  Future<bool> getIntialCreateBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_intialCreateBudget) ?? false;
  }

  // Setters and Getters for initial setting
  Future<void> setInitialSetting({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_initialSetting, value);
  }

  Future<bool> getInitialSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_initialSetting) ?? false;
  }

  // Setters and Getters for theme mode
  Future<void> setThemeMode(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeMode, value);
  }

  Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeMode) ?? 'Dark Mode';
  }

  // Setters and Getters for currency code
  Future<void> setCurrencyCode(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currency, value);
  }

  Future<String> getCurrencyCode() async {
    final prefs = await SharedPreferences.getInstance();
    final currency = prefs.getString(_currency);
    final defaultLocale = Platform.localeName;

    if (currency != null) {
      return currency;
    } else {
      if (defaultLocale != 'id_ID') {
        return 'USD';
      } else {
        return 'IDR';
      }
    }
  }

  // Setters and Getters for language
  Future<void> setLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_language, value);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString(_language);
    final defaultLocale = Platform.localeName;

    if (language != null) {
      return language;
    } else {
      if (defaultLocale != 'id_ID') {
        return 'English';
      } else {
        return 'Indonesia';
      }
    }
  }

  // Setters and Getters for use biometrics
  Future<void> setUseBiometrics({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useBiometrics, value);
  }

  Future<bool> getUseBiometrics() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_useBiometrics) ?? true;
  }

  // Setters and Getters for authentication status
  Future<void> setIsAuthenticated({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAuthenticated, value);
    if (value) {
      final now = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_authTimestamp, now);
    } else {
      await prefs.remove(_authTimestamp); // Clear the timestamp if logged out
    }
  }

  Future<bool> getIsAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool(_isAuthenticated) ?? false;

    if (isAuthenticated) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final authTimestamp = prefs.getInt(_authTimestamp) ?? 0;

      // Check if the session has expired
      if (DateTime.fromMillisecondsSinceEpoch(now)
              .difference(DateTime.fromMillisecondsSinceEpoch(authTimestamp)) >
          _sessionDuration) {
        await setIsAuthenticated(value: false); // Session expired
        return false;
      }
    }

    return isAuthenticated;
  }

  // Setters and Getters for use biometrics
  Future<void> setNotificationEnable({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnable, value);
  }

  Future<bool> getNotificationEnable() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationEnable) ?? true;
  }

  Future<void> setSchedulePaymentNotification({
    required bool value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_schedulePaymentNotification, value);
  }

  Future<bool?> getSchedulePaymentNotification() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_schedulePaymentNotification);
  }

  // Setters and Getters for only financial tracker
  Future<void> setOnlyFinancialTracker({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onlyFinancialTracker, value);
  }

  Future<bool> getOnlyFinancialTracker() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onlyFinancialTracker) ?? false;
  }
}
