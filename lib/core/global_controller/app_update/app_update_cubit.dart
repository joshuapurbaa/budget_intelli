import 'package:budget_intelli/core/services/update_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_update_state.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  AppUpdateCubit() : super(AppUpdateInitial());

  final UpdateService _updateService = UpdateService();

  /// Check for app updates
  Future<void> checkForUpdates() async {
    emit(AppUpdateChecking());

    try {
      final updateInfo = await _updateService.checkForUpdate();

      if (updateInfo.availability == AppUpdateAvailability.available) {
        emit(AppUpdateAvailable(updateInfo));
      } else {
        emit(AppUpdateNotAvailable(updateInfo));
      }
    } catch (e) {
      emit(AppUpdateError('Failed to check for updates: $e'));
    }
  }

  /// Start flexible update
  Future<void> startFlexibleUpdate() async {
    emit(AppUpdateDownloading());

    try {
      final success = await _updateService.startFlexibleUpdate();
      if (success) {
        emit(AppUpdateDownloaded());
      } else {
        emit(const AppUpdateError('Failed to start flexible update'));
      }
    } catch (e) {
      emit(AppUpdateError('Failed to start flexible update: $e'));
    }
  }

  /// Start immediate update
  Future<void> startImmediateUpdate() async {
    emit(AppUpdateDownloading());

    try {
      await _updateService.startImmediateUpdate();
      // If we reach here, the update was completed and app restarted
      emit(AppUpdateCompleted());
    } catch (e) {
      emit(AppUpdateError('Failed to start immediate update: $e'));
    }
  }

  /// Complete flexible update
  Future<void> completeFlexibleUpdate() async {
    emit(AppUpdateInstalling());

    try {
      await _updateService.completeFlexibleUpdate();
      emit(AppUpdateCompleted());
    } catch (e) {
      emit(AppUpdateError('Failed to complete flexible update: $e'));
    }
  }

  /// Open app store for manual update
  Future<void> openAppStore() async {
    try {
      await _updateService.openAppStore();
    } catch (e) {
      emit(AppUpdateError('Failed to open app store: $e'));
    }
  }

  /// Dismiss update prompt
  void dismissUpdate() {
    emit(AppUpdateDismissed());
  }

  /// Reset state
  void reset() {
    emit(AppUpdateInitial());
  }

  /// Clear cache and force new check
  void clearCacheAndCheck() {
    _updateService.clearCache();
    checkForUpdates();
  }
}
