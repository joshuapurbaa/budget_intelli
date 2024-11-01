part of 'settings_bloc.dart';

@immutable
sealed class SettingEvent {}

class LanguageChange extends SettingEvent {
  LanguageChange(this.language);

  final Language language;
}

class CurrencyChange extends SettingEvent {
  CurrencyChange(this.currency);

  final CurrencyModel currency;
}

class ThemeModeChange extends SettingEvent {
  ThemeModeChange(this.themeMode);

  final IntelliThemeMode themeMode;
}

class GetUserSettingEvent extends SettingEvent {}

class GetLanguageEvent extends SettingEvent {}

class SetUserName extends SettingEvent {
  SetUserName(this.name);

  final String? name;
}

class SetUserEmail extends SettingEvent {
  SetUserEmail(this.email);

  final String? email;
}

class SetUserIsLoggedIn extends SettingEvent {
  SetUserIsLoggedIn({required this.isLoggedIn});

  final bool isLoggedIn;
}

class SetUserIsPremiumUser extends SettingEvent {
  SetUserIsPremiumUser({required this.isPremiumUser});

  final bool isPremiumUser;
}

class SetUserAlreadySetInitialSetting extends SettingEvent {
  SetUserAlreadySetInitialSetting({required this.alreadySetInitialSetting});

  final bool alreadySetInitialSetting;
}

class SetUserAlreadySetInitialCreateBudget extends SettingEvent {
  SetUserAlreadySetInitialCreateBudget({
    required this.alreadySetInitialCreateBudget,
  });

  final bool alreadySetInitialCreateBudget;
}

class SetUserContinueWithoutLogin extends SettingEvent {
  SetUserContinueWithoutLogin({required this.continueWithoutLogin});

  final bool continueWithoutLogin;
}

class SetUserLastSeenBudgetId extends SettingEvent {
  SetUserLastSeenBudgetId({required this.lastSeenBudgetId});

  final String lastSeenBudgetId;
}

class ClearLastSeenBudgetIdEvent extends SettingEvent {}

class SetUserUidEvent extends SettingEvent {
  SetUserUidEvent(this.uid);

  final String uid;
}

class SetUserIntelli extends SettingEvent {
  SetUserIntelli(this.user);

  final UserIntelli user;
}

class ExportDataEvent extends SettingEvent {
  ExportDataEvent({
    required this.pdfContentList,
    required this.periodString,
    required this.language,
    required this.summaryDescription,
    required this.totalPlannedAmountIncome,
    required this.totalActualAmountIncome,
    required this.totalActualAmountExpense,
    required this.totalPlannedAmountExpense,
  });

  final List<PdfContentModel> pdfContentList;
  final String periodString;
  final String language;
  final String summaryDescription;
  final String totalPlannedAmountIncome;
  final String totalActualAmountIncome;
  final String totalPlannedAmountExpense;
  final String totalActualAmountExpense;
}

class BiometricSettingChange extends SettingEvent {
  BiometricSettingChange({required this.value});

  final bool value;
}

class AuthenticationChange extends SettingEvent {
  AuthenticationChange({required this.value});

  final bool value;
}

class NotificationChange extends SettingEvent {
  NotificationChange({required this.value});

  final bool value;
}

class SetOnlyFinancialTrackerChange extends SettingEvent {
  SetOnlyFinancialTrackerChange({required this.value});

  final bool value;
}
