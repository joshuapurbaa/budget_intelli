part of 'settings_bloc.dart';

@immutable
final class SettingState {
  const SettingState({
    required this.currency,
    this.selectedLanguage = Language.english,
    this.themeMode = ThemeMode.system,
    this.isDarkMode = false,
    this.name,
    this.email,
    this.isLoggedIn = false,
    this.alreadySetInitialSetting,
    this.alreadySetInitialCreateBudget,
    this.onlyFinancialTracker,
    this.imageUrl = '-',
    this.premiumUser = false,
    this.continueWithoutLogin = false,
    this.lastSeenBudgetId,
    this.loading = false,
    this.uid,
    this.user,
    this.pdfBytes,
    this.useBiometrics = true,
    this.isAuthenticated = false,
    this.notificationEnable = true,
    this.hideFinancialTracker = true,
    this.showAmount = false,
  });

  final Language selectedLanguage;
  final CurrencyModel currency;
  final ThemeMode themeMode;
  final bool isDarkMode;
  final String? name;
  final String? email;
  final bool isLoggedIn;
  final bool? alreadySetInitialSetting;
  final bool? alreadySetInitialCreateBudget;
  final bool? onlyFinancialTracker;
  final String imageUrl;
  final bool premiumUser;
  final bool continueWithoutLogin;
  final String? lastSeenBudgetId;
  final bool loading;
  final String? uid;
  final UserIntelli? user;
  final Uint8List? pdfBytes;
  final bool useBiometrics;
  final bool isAuthenticated;
  final bool notificationEnable;
  final bool hideFinancialTracker;
  final bool showAmount;

  SettingState copyWith({
    Language? selectedLanguage,
    CurrencyModel? currency,
    ThemeMode? themeMode,
    bool? isDarkMode,
    String? name,
    String? email,
    bool? isLoggedIn,
    bool? alreadySetInitialSetting,
    bool? alreadySetInitialCreateBudget,
    bool? onlyFinancialTracker,
    String? imageUrl,
    bool? premiumUser,
    bool? continueWithoutLogin,
    String? lastSeenBudgetId,
    bool? loading,
    String? uid,
    UserIntelli? user,
    Uint8List? pdfBytes,
    bool? useBiometrics,
    bool? isAuthenticated,
    bool? notificationEnable,
    bool? hideFinancialTracker,
    bool? showAmount,
  }) {
    return SettingState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      currency: currency ?? this.currency,
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      name: name ?? this.name,
      email: email ?? this.email,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      alreadySetInitialSetting:
          alreadySetInitialSetting ?? this.alreadySetInitialSetting,
      alreadySetInitialCreateBudget:
          alreadySetInitialCreateBudget ?? this.alreadySetInitialCreateBudget,
      onlyFinancialTracker: onlyFinancialTracker ?? this.onlyFinancialTracker,
      imageUrl: imageUrl ?? this.imageUrl,
      premiumUser: premiumUser ?? this.premiumUser,
      continueWithoutLogin: continueWithoutLogin ?? this.continueWithoutLogin,
      lastSeenBudgetId: lastSeenBudgetId ?? this.lastSeenBudgetId,
      loading: loading ?? this.loading,
      uid: uid ?? this.uid,
      user: user ?? this.user,
      pdfBytes: pdfBytes ?? this.pdfBytes,
      useBiometrics: useBiometrics ?? this.useBiometrics,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      notificationEnable: notificationEnable ?? this.notificationEnable,
      hideFinancialTracker: hideFinancialTracker ?? this.hideFinancialTracker,
      showAmount: showAmount ?? this.showAmount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingState &&
        other.selectedLanguage == selectedLanguage &&
        other.currency == currency &&
        other.themeMode == themeMode &&
        other.isDarkMode == isDarkMode &&
        other.name == name &&
        other.email == email &&
        other.isLoggedIn == isLoggedIn &&
        other.alreadySetInitialSetting == alreadySetInitialSetting &&
        other.alreadySetInitialCreateBudget == alreadySetInitialCreateBudget &&
        other.imageUrl == imageUrl &&
        other.premiumUser == premiumUser &&
        other.continueWithoutLogin == continueWithoutLogin &&
        other.lastSeenBudgetId == lastSeenBudgetId &&
        other.loading == loading &&
        other.uid == uid &&
        other.user == user &&
        other.pdfBytes == pdfBytes &&
        other.useBiometrics == useBiometrics &&
        other.notificationEnable == notificationEnable &&
        other.isAuthenticated == isAuthenticated &&
        other.hideFinancialTracker == hideFinancialTracker &&
        other.showAmount == showAmount;
  }

  @override
  int get hashCode =>
      selectedLanguage.hashCode ^
      currency.hashCode ^
      themeMode.hashCode ^
      isDarkMode.hashCode ^
      name.hashCode ^
      email.hashCode ^
      isLoggedIn.hashCode ^
      alreadySetInitialSetting.hashCode ^
      alreadySetInitialCreateBudget.hashCode ^
      imageUrl.hashCode ^
      premiumUser.hashCode ^
      continueWithoutLogin.hashCode ^
      lastSeenBudgetId.hashCode ^
      loading.hashCode ^
      uid.hashCode ^
      user.hashCode ^
      pdfBytes.hashCode ^
      useBiometrics.hashCode ^
      notificationEnable.hashCode ^
      isAuthenticated.hashCode ^
      hideFinancialTracker.hashCode ^
      showAmount.hashCode;
}
