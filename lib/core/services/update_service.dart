import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum AppUpdateAvailability {
  none,
  available,
  required,
  unknown,
}

class AppUpdateInfo {

  const AppUpdateInfo({
    required this.availability,
    this.availableVersion,
    this.currentVersion,
    this.isFlexibleUpdateAllowed = false,
    this.isImmediateUpdateAllowed = false,
  });
  final AppUpdateAvailability availability;
  final String? availableVersion;
  final String? currentVersion;
  final bool isFlexibleUpdateAllowed;
  final bool isImmediateUpdateAllowed;
}

class UpdateService {
  factory UpdateService() => _instance;
  UpdateService._internal();
  static final UpdateService _instance = UpdateService._internal();

  AppUpdateInfo? _lastUpdateInfo;
  DateTime? _lastCheckTime;
  static const Duration _checkInterval = Duration(hours: 6);

  /// Check for app updates
  Future<AppUpdateInfo> checkForUpdate() async {
    try {
      // Return cached result if checked recently
      if (_lastUpdateInfo != null &&
          _lastCheckTime != null &&
          DateTime.now().difference(_lastCheckTime!) < _checkInterval) {
        return _lastUpdateInfo!;
      }

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      if (Platform.isAndroid) {
        return await _checkAndroidUpdate(currentVersion);
      } else if (Platform.isIOS) {
        return await _checkIOSUpdate(currentVersion);
      } else {
        return AppUpdateInfo(
          availability: AppUpdateAvailability.none,
          currentVersion: currentVersion,
        );
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      return AppUpdateInfo(
        availability: AppUpdateAvailability.unknown,
        currentVersion:
            await PackageInfo.fromPlatform().then((info) => info.version),
      );
    }
  }

  /// Check for Android updates using Google Play's in-app update API
  Future<AppUpdateInfo> _checkAndroidUpdate(String currentVersion) async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      _lastCheckTime = DateTime.now();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        final appUpdateInfo = AppUpdateInfo(
          availability: AppUpdateAvailability.available,
          currentVersion: currentVersion,
          availableVersion: updateInfo.availableVersionCode?.toString(),
          isFlexibleUpdateAllowed: updateInfo.flexibleUpdateAllowed,
          isImmediateUpdateAllowed: updateInfo.immediateUpdateAllowed,
        );
        _lastUpdateInfo = appUpdateInfo;
        return appUpdateInfo;
      } else {
        final appUpdateInfo = AppUpdateInfo(
          availability: AppUpdateAvailability.none,
          currentVersion: currentVersion,
        );
        _lastUpdateInfo = appUpdateInfo;
        return appUpdateInfo;
      }
    } catch (e) {
      debugPrint('Error checking Android update: $e');
      return AppUpdateInfo(
        availability: AppUpdateAvailability.unknown,
        currentVersion: currentVersion,
      );
    }
  }

  /// Check for iOS updates (simplified version - opens App Store)
  Future<AppUpdateInfo> _checkIOSUpdate(String currentVersion) async {
    // For iOS, we can't check for updates programmatically like Android
    // This is a simplified implementation that could be enhanced with server-side version checking
    _lastCheckTime = DateTime.now();

    final appUpdateInfo = AppUpdateInfo(
      availability: AppUpdateAvailability
          .none, // Would need server-side check for real implementation
      currentVersion: currentVersion,
    );
    _lastUpdateInfo = appUpdateInfo;
    return appUpdateInfo;
  }

  /// Start flexible update for Android
  Future<bool> startFlexibleUpdate() async {
    if (!Platform.isAndroid) return false;

    try {
      final result = await InAppUpdate.startFlexibleUpdate();
      return result == AppUpdateResult.success;
    } catch (e) {
      debugPrint('Error starting flexible update: $e');
      return false;
    }
  }

  /// Start immediate update for Android
  Future<bool> startImmediateUpdate() async {
    if (!Platform.isAndroid) return false;

    try {
      await InAppUpdate.performImmediateUpdate();
      return true;
    } catch (e) {
      debugPrint('Error starting immediate update: $e');
      return false;
    }
  }

  /// Complete flexible update for Android
  Future<bool> completeFlexibleUpdate() async {
    if (!Platform.isAndroid) return false;

    try {
      await InAppUpdate.completeFlexibleUpdate();
      return true;
    } catch (e) {
      debugPrint('Error completing flexible update: $e');
      return false;
    }
  }

  /// Open app store for manual update
  Future<bool> openAppStore() async {
    try {
      if (Platform.isAndroid) {
        const url =
            'https://play.google.com/store/apps/details?id=com.porseatechnology.budgetIntelli';
        return await launchUrl(Uri.parse(url));
      } else if (Platform.isIOS) {
        // Replace with your actual App Store URL
        const url = 'https://apps.apple.com/app/budget-intelli/idYOUR_APP_ID';
        return await launchUrl(Uri.parse(url));
      }
      return false;
    } catch (e) {
      debugPrint('Error opening app store: $e');
      return false;
    }
  }

  /// Clear cached update info to force fresh check
  void clearCache() {
    _lastUpdateInfo = null;
    _lastCheckTime = null;
  }
}
