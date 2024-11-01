part of 'preference_cubit.dart';

@immutable
class PreferenceState {
  const PreferenceState({
    this.selectedLanguage,
    this.currency,
    this.themeMode,
    this.isDarkMode,
    this.name,
    this.email,
    this.isLoggedIn,
    this.alreadySetInitialSetting,
    this.alreadySetInitialCreateBudget,
    this.imageUrl,
    this.premiumUser,
    this.continueWithoutLogin,
    this.lastSeenBudgetId,
    this.loading,
    this.uid,
  });

  final Language? selectedLanguage;
  final CurrencyModel? currency;
  final ThemeMode? themeMode;
  final bool? isDarkMode;
  final String? name;
  final String? email;
  final bool? isLoggedIn;
  final bool? alreadySetInitialSetting;
  final bool? alreadySetInitialCreateBudget;
  final String? imageUrl;
  final bool? premiumUser;
  final bool? continueWithoutLogin;
  final String? lastSeenBudgetId;
  final bool? loading;
  final String? uid;

  PreferenceState copyWith({
    Language? selectedLanguage,
    CurrencyModel? currency,
    ThemeMode? themeMode,
    bool? isDarkMode,
    String? name,
    String? email,
    bool? isLoggedIn,
    bool? alreadySetInitialSetting,
    bool? alreadySetInitialCreateBudget,
    String? imageUrl,
    bool? premiumUser,
    bool? continueWithoutLogin,
    String? lastSeenBudgetId,
    bool? loading,
    String? uid,
  }) {
    return PreferenceState(
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
      imageUrl: imageUrl ?? this.imageUrl,
      premiumUser: premiumUser ?? this.premiumUser,
      continueWithoutLogin: continueWithoutLogin ?? this.continueWithoutLogin,
      lastSeenBudgetId: lastSeenBudgetId ?? this.lastSeenBudgetId,
      loading: loading ?? this.loading,
      uid: uid ?? this.uid,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PreferenceState &&
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
        other.uid == uid;
  }

  @override
  int get hashCode {
    return selectedLanguage.hashCode ^
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
        uid.hashCode;
  }
}
