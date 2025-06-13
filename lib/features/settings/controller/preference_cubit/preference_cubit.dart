import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'preference_state.dart';

class PreferenceCubit extends Cubit<PreferenceState> {
  PreferenceCubit({
    required SettingPreferenceRepo settingRepository,
    required UserPreferenceRepo userPreferenceRepo,
  })  : _settingRepository = settingRepository,
        _userPreferenceRepo = userPreferenceRepo,
        super(
          const PreferenceState(),
        );

  final SettingPreferenceRepo _settingRepository;
  final UserPreferenceRepo _userPreferenceRepo;

  // get uid
  Future<String?> getUserUid() async {
    final uid = await _userPreferenceRepo.getUid();
    emit(state.copyWith(uid: uid));
    return uid;
  }

  // already set initial create budget
  Future<bool> getAlreadySetInitialCreateBudget() async {
    final alreadySetInitialCreateBudget =
        await _settingRepository.getIntialCreateBudget();
    emit(
      state.copyWith(
        alreadySetInitialCreateBudget: alreadySetInitialCreateBudget,
      ),
    );
    return alreadySetInitialCreateBudget;
  }

  // continue without login
  Future<bool> getContinueWithoutLogin() async {
    final continueWithoutLogin =
        await _userPreferenceRepo.getContinueWithoutLogin();
    emit(state.copyWith(continueWithoutLogin: continueWithoutLogin));
    return continueWithoutLogin;
  }

  // already set initial setting
  Future<bool> getAlreadySetInitialSetting() async {
    final alreadySetInitialSetting =
        await _settingRepository.getInitialSetting();
    emit(state.copyWith(alreadySetInitialSetting: alreadySetInitialSetting));
    return alreadySetInitialSetting;
  }

//   get language
  Future<String?> getLanguage() async {
    final language = await _settingRepository.getLanguage();
    final selectedLanguage = Language.values.firstWhere(
      (element) => element.text == language,
      orElse: () => Language.indonesia,
    );
    emit(state.copyWith(selectedLanguage: selectedLanguage));
    return language;
  }
}
