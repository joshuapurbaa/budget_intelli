// ignore_for_file: use_build_context_synchronously

import 'package:app_settings/app_settings.dart';
import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class BiometricAuth extends StatefulWidget {
  const BiometricAuth({
    super.key,
  });

  @override
  State<BiometricAuth> createState() => _BiometricAuthState();
}

class _BiometricAuthState extends State<BiometricAuth> {
  late LocalAuthentication auth;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    final localize = textLocalizer(context);
    try {
      final didAuthenticate = await auth.authenticate(
        localizedReason: localize.pleaseAuthenticateToShowBudget,
        authMessages: <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: localize.oopsBiometricAuthenticationRequired,
            cancelButton: localize.noThanks,
          ),
        ],
      );

      if (didAuthenticate) {
        final settingPrefs = SettingPreferenceRepo();
        await settingPrefs.setIsAuthenticated(value: true);
        if (!mounted) {
          return;
        } else {
          context.read<SettingBloc>().add(
                GetUserSettingEvent(),
              );

          context.go(MyRoute.main);
        }
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case auth_error.notEnrolled:
          _showEnrollmentPrompt(context);

        case auth_error.lockedOut:
          _showErrorDialog(
            context,
            localize.biometricTemporarilyLockedOut,
          );
          Future.delayed(const Duration(seconds: 2), SystemNavigator.pop);

        case auth_error.permanentlyLockedOut:
          _showErrorDialog(
            context,
            localize.biometricPermanentlyLockedOut,
          );

        case auth_error.passcodeNotSet:
          _showErrorDialog(
            context,
            'No passcode is set on this device. Please set a passcode to use biometrics.',
          );

        case auth_error.notAvailable:
          _showNotSetupDialog(
            context,
            localize.biometricNotSetUp,
          );

        default:
          _showErrorDialog(
            context,
            'An unspecified error occurred: ${e.message}',
          );
      }
    } on Exception catch (e) {
      _showErrorDialog(context, 'An unexpected error occurred: $e');
    }
  }

  void _showEnrollmentPrompt(BuildContext context) {
    final localize = textLocalizer(context);
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localize.setUpBiometrics,
          ),
          content: Text(
            localize.biometricNotSetUp,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localize.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openBiometricSettings();
              },
              child: Text(localize.openSettings),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openBiometricSettings() async {
    await AppSettings.openAppSettings(
      type: AppSettingsType.security,
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            textLocalizer(context).authenticationError,
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // _openBiometricSettings();
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNotSetupDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            textLocalizer(context).authenticationFailed,
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _openBiometricSettings();
                Navigator.of(context).pop();
              },
              child: Text(
                textLocalizer(context).setUp,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              identityPng,
              color: context.color.onSurface,
              width: MediaQuery.sizeOf(context).width * 0.5,
            ),
            Gap.vertical(32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppButton(
                label: localize.authenticate,
                onPressed: _authenticate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
