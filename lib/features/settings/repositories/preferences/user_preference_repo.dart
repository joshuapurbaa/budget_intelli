import 'package:shared_preferences/shared_preferences.dart';

class UserPreferenceRepo {
  static const String _name = 'name';
  static const String _email = 'email';
  static const String _isLoggedIn = 'isLoggedIn';
  static const String _isPremiumUser = 'premium-user';
  static const String _continueWithoutLogin = 'continueWithoutLogin';
  static const String _lastSeenBudgetId = 'lastSeenBudgetId';
  static const String _uid = 'uid';

  Future<void> setName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_name, value);
  }

  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_name);
  }

  Future<void> setEmail(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_email, value);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_email);
  }

  Future<void> setIsLoggedIn({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedIn, value);
  }

  Future<bool> getIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedIn) ?? false;
  }

  Future<void> setIsPremiumUser({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPremiumUser, value);
  }

  Future<bool> getIsPremiumUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isPremiumUser) ?? false;
  }

  Future<void> setContinueWithoutLogin({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_continueWithoutLogin, value);
  }

  Future<bool> getContinueWithoutLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_continueWithoutLogin) ?? false;
  }

  Future<void> setLastSeenBudgetId({required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSeenBudgetId, value);
  }

  Future<String?> getLastSeenBudgetId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSeenBudgetId);
  }

  Future<void> clearLastSeenBudgetId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastSeenBudgetId);
  }

  Future<void> setUid({required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uid, value);
  }

  Future<String?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uid);
  }

  Future<void> clearUid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_uid);
  }
}
