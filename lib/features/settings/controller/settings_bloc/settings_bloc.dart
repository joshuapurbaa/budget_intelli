import 'dart:typed_data';

import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/settings/models/pdf_content_model.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc({
    required SettingPreferenceRepo preferenceRepository,
    required UserPreferenceRepo userPreferenceRepo,
    required PdfRepository pdfRepository,
  })  : _settingRepository = preferenceRepository,
        _userPreferenceRepo = userPreferenceRepo,
        _pdfRepository = pdfRepository,
        super(
          SettingState(
            currency: CurrencyModel.initial,
          ),
        ) {
    on<LanguageChange>(_onLanguageChange);
    on<CurrencyChange>(_onCurrencyChange);
    on<ThemeModeChange>(_onThemeModeChange);
    on<GetUserSettingEvent>(_onGetUserSettingEvent);
    on<GetLanguageEvent>(_onGetLanguageEvent);
    on<SetUserName>(_onSetUserName);
    on<SetUserEmail>(_onSetUserEmail);
    on<SetUserIsLoggedIn>(_onSetUserIsLoggedIn);
    on<SetUserIsPremiumUser>(_onSetUserIsPremiumUser);
    on<SetUserAlreadySetInitialSetting>(_onSetUserAlreadySetInitialSetting);
    on<SetOnlyFinancialTrackerChange>(_onOnlyFinancialTrackerChange);
    on<SetUserAlreadySetInitialCreateBudget>(
      _onSetUserAlreadySetInitialCreateBudget,
    );
    on<SetUserContinueWithoutLogin>(_onSetUserContinueWithoutLogin);
    on<SetUserLastSeenBudgetId>(_onSetUserLastSeenBudgetId);
    on<ClearLastSeenBudgetIdEvent>(_onClearLastSeenBudgetIdEvent);
    on<SetUserUidEvent>(_onSetUserUidEvent);
    on<SetUserIntelli>(_onSetUserIntelli);
    on<ExportDataEvent>(_onExportDataEvent);
    on<BiometricSettingChange>(_onBiometricSettingChange);
    on<AuthenticationChange>(_onAuthenticationChange);
    on<NotificationChange>(_onNotificationChange);
    on<UpdateShowAmountEvent>(_onUpdateShowAmount);
  }

  final SettingPreferenceRepo _settingRepository;
  final UserPreferenceRepo _userPreferenceRepo;
  final PdfRepository _pdfRepository;

  Future<void> _onGetLanguageEvent(
    GetLanguageEvent event,
    Emitter<SettingState> emit,
  ) async {
    final language = await _settingRepository.getLanguage();
    final selectedLanguage = Language.values.firstWhere(
      (element) => element.text == language,
      orElse: () => Language.indonesia,
    );

    emit(state.copyWith(selectedLanguage: selectedLanguage));
  }

  Future<void> _onGetUserSettingEvent(
    GetUserSettingEvent event,
    Emitter<SettingState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final language = await _settingRepository.getLanguage();
    final currencyCode = await _settingRepository.getCurrencyCode();
    final themeMode = await _settingRepository.getThemeMode();
    final alreadySetInitialSetting =
        await _settingRepository.getInitialSetting();
    final isInitialCreateBudget =
        await _settingRepository.getIntialCreateBudget();
    final name = await _userPreferenceRepo.getName();
    final email = await _userPreferenceRepo.getEmail();
    final isLoggedIn = await _userPreferenceRepo.getIsLoggedIn();
    final premiumUser = await _userPreferenceRepo.getIsPremiumUser();
    final continueWithoutLogin =
        await _userPreferenceRepo.getContinueWithoutLogin();
    final uid = await _userPreferenceRepo.getUid();

    final selectedLanguage = Language.values.firstWhere(
      (element) => element.text == language,
      orElse: () => Language.indonesia,
    );
    final lastSeenBudgetId = await _userPreferenceRepo.getLastSeenBudgetId();

    final selectedCurrency = WorldCurrency.currencyList.firstWhere(
      (element) => element.code == currencyCode,
      orElse: () => CurrencyModel.initial,
    );

    final selectedThemeMode = IntelliThemeMode.values.firstWhere(
      (element) => element.name == themeMode,
      orElse: () => IntelliThemeMode.system,
    );

    final useBiometrics = await _settingRepository.getUseBiometrics();
    final authenticated = await _settingRepository.getIsAuthenticated();
    final notificationEnable = await _settingRepository.getNotificationEnable();
    final showAmount = await _settingRepository.getShowAmount();
    emit(
      state.copyWith(
        selectedLanguage: selectedLanguage,
        currency: selectedCurrency,
        themeMode: selectedThemeMode.themeMode,
        name: name,
        email: email,
        isLoggedIn: isLoggedIn,
        alreadySetInitialSetting: alreadySetInitialSetting,
        alreadySetInitialCreateBudget: isInitialCreateBudget,
        premiumUser: premiumUser,
        continueWithoutLogin: continueWithoutLogin,
        lastSeenBudgetId: lastSeenBudgetId,
        loading: false,
        uid: uid,
        useBiometrics: useBiometrics,
        isAuthenticated: authenticated,
        notificationEnable: notificationEnable,
        showAmount: showAmount,
      ),
    );
  }

  Future<void> _onLanguageChange(
    LanguageChange event,
    Emitter<SettingState> emit,
  ) async {
    final language = event.language.text;
    await _settingRepository.setLanguage(language);
    emit(
      state.copyWith(selectedLanguage: event.language),
    );
  }

  Future<void> _onCurrencyChange(
    CurrencyChange event,
    Emitter<SettingState> emit,
  ) async {
    final currency = event.currency.code;
    await _settingRepository.setCurrencyCode(currency);
    emit(
      state.copyWith(currency: event.currency),
    );
  }

  Future<void> _onThemeModeChange(
    ThemeModeChange event,
    Emitter<SettingState> emit,
  ) async {
    final themeMode = event.themeMode.name;
    await _settingRepository.setThemeMode(themeMode);

    final isDarkMode = event.themeMode.themeMode == ThemeMode.dark;

    emit(
      state.copyWith(
        themeMode: event.themeMode.themeMode,
        isDarkMode: isDarkMode,
      ),
    );
  }

  Future<void> _onBiometricSettingChange(
    BiometricSettingChange event,
    Emitter<SettingState> emit,
  ) async {
    await _settingRepository.setUseBiometrics(
      value: event.value,
    );

    emit(
      state.copyWith(
        useBiometrics: event.value,
      ),
    );
  }

  Future<void> _onAuthenticationChange(
    AuthenticationChange event,
    Emitter<SettingState> emit,
  ) async {
    await _settingRepository.setIsAuthenticated(
      value: event.value,
    );

    emit(
      state.copyWith(
        isAuthenticated: event.value,
      ),
    );
  }

  Future<void> _onNotificationChange(
    NotificationChange event,
    Emitter<SettingState> emit,
  ) async {
    await _settingRepository.setNotificationEnable(value: event.value);

    emit(
      state.copyWith(
        notificationEnable: event.value,
      ),
    );
  }

  Future<void> _onSetUserName(
    SetUserName event,
    Emitter<SettingState> emit,
  ) async {
    if (event.name != null) {
      await _userPreferenceRepo.setName(event.name!);
      emit(state.copyWith(name: event.name));
    }
  }

  Future<void> _onSetUserEmail(
    SetUserEmail event,
    Emitter<SettingState> emit,
  ) async {
    if (event.email != null) {
      await _userPreferenceRepo.setEmail(event.email!);
      emit(state.copyWith(email: event.email));
    }
  }

  Future<void> _onSetUserIsLoggedIn(
    SetUserIsLoggedIn event,
    Emitter<SettingState> emit,
  ) async {
    await _userPreferenceRepo.setIsLoggedIn(value: event.isLoggedIn);
    emit(state.copyWith(isLoggedIn: event.isLoggedIn));
  }

  Future<void> _onSetUserIsPremiumUser(
    SetUserIsPremiumUser event,
    Emitter<SettingState> emit,
  ) async {
    await _userPreferenceRepo.setIsPremiumUser(value: event.isPremiumUser);
    emit(state.copyWith(premiumUser: event.isPremiumUser));
  }

  Future<void> _onSetUserAlreadySetInitialSetting(
    SetUserAlreadySetInitialSetting event,
    Emitter<SettingState> emit,
  ) async {
    await _settingRepository.setInitialSetting(
      value: event.alreadySetInitialSetting,
    );
    emit(
      state.copyWith(
        alreadySetInitialSetting: event.alreadySetInitialSetting,
      ),
    );
  }

  Future<void> _onSetUserAlreadySetInitialCreateBudget(
    SetUserAlreadySetInitialCreateBudget event,
    Emitter<SettingState> emit,
  ) async {
    await _settingRepository.setIntialCreateBudget(
      value: event.alreadySetInitialCreateBudget,
    );
    emit(
      state.copyWith(
        alreadySetInitialCreateBudget: event.alreadySetInitialCreateBudget,
      ),
    );
  }

  Future<void> _onSetUserContinueWithoutLogin(
    SetUserContinueWithoutLogin event,
    Emitter<SettingState> emit,
  ) async {
    await _userPreferenceRepo.setContinueWithoutLogin(
      value: event.continueWithoutLogin,
    );
    emit(state.copyWith(continueWithoutLogin: event.continueWithoutLogin));
  }

  Future<void> _onSetUserLastSeenBudgetId(
    SetUserLastSeenBudgetId event,
    Emitter<SettingState> emit,
  ) async {
    await _userPreferenceRepo.setLastSeenBudgetId(
      value: event.lastSeenBudgetId,
    );
    emit(state.copyWith(lastSeenBudgetId: event.lastSeenBudgetId));
  }

  Future<void> _onClearLastSeenBudgetIdEvent(
    ClearLastSeenBudgetIdEvent event,
    Emitter<SettingState> emit,
  ) async {
    await _userPreferenceRepo.clearLastSeenBudgetId();
    emit(
      state.copyWith(
        lastSeenBudgetId: '',
      ),
    );
  }

  Future<void> _onSetUserUidEvent(
    SetUserUidEvent event,
    Emitter<SettingState> emit,
  ) async {
    await _userPreferenceRepo.setUid(value: event.uid);
    emit(state.copyWith(uid: event.uid));
  }

  Future<void> _onSetUserIntelli(
    SetUserIntelli event,
    Emitter<SettingState> emit,
  ) async {
    emit(
      state.copyWith(
        user: event.user,
      ),
    );
  }

  Future<void> _onExportDataEvent(
    ExportDataEvent event,
    Emitter<SettingState> emit,
  ) async {
    final data = await _pdfRepository.generatePdf(
      pdfContentList: event.pdfContentList,
      period: event.periodString,
      language: event.language,
      summaryDescription: event.summaryDescription,
      totalPlannedAmountIncome: event.totalActualAmountIncome,
      totalActualAmountIncome: event.totalActualAmountIncome,
      totalPlannedAmountExpense: event.totalPlannedAmountExpense,
      totalActualAmountExpense: event.totalActualAmountExpense,
    );
    await _pdfRepository.savePdf('budget_intelli', data);
  }

  Future<void> _onOnlyFinancialTrackerChange(
    SetOnlyFinancialTrackerChange event,
    Emitter<SettingState> emit,
  ) async {
    await _settingRepository.setOnlyFinancialTracker(
      value: event.value,
    );
    emit(
      state.copyWith(
        onlyFinancialTracker: event.value,
      ),
    );
  }

  Future<void> _onUpdateShowAmount(
    UpdateShowAmountEvent event,
    Emitter<SettingState> emit,
  ) async {
    await _settingRepository.setShowAmount(value: event.showAmount);
    emit(state.copyWith(showAmount: event.showAmount));
  }
}
