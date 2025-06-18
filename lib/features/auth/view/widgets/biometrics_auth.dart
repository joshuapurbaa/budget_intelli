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
      if (!mounted) return;

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
            localize.noPasscodeSet,
          );

        case auth_error.notAvailable:
          _showNotSetupDialog(
            context,
            localize.biometricNotSetUp,
          );

        default:
          _showErrorDialog(
            context,
            localize.unspecifiedError(e.message ?? ''),
          );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      _showErrorDialog(context, localize.unexpectedError(e.toString()));
    }
  }

  void _showEnrollmentPrompt(BuildContext context) {
    final localize = textLocalizer(context);

    AppDialog.showCustomDialog(
      context,
      title: AppText(
        text: localize.setUpBiometrics,
        style: StyleType.headMed,
      ),
      content: AppText(
        text: localize.biometricNotSetUp,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: AppText(
            text: localize.cancel,
            style: StyleType.bodMed,
          ),
        ),
        TextButton(
          onPressed: () {
            context.pop();
            _authenticate();
          },
          child: AppText(
            text: localize.tryAgain,
            style: StyleType.bodMed,
          ),
        ),
        TextButton(
          onPressed: () {
            context.pop();
            _openBiometricSettings();
          },
          child: AppText(
            text: localize.openSettings,
            style: StyleType.bodMed,
          ),
        ),
      ],
    );
  }

  Future<void> _openBiometricSettings() async {
    await AppSettings.openAppSettings(
      type: AppSettingsType.security,
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    final localize = textLocalizer(context);

    AppDialog.showCustomDialog(
      context,
      title: AppText(
        text: localize.authenticationError,
        style: StyleType.headMed,
      ),
      content: AppText(text: message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: AppText(
            text: localize.ok,
            style: StyleType.bodMed,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _authenticate();
          },
          child: AppText(
            text: localize.tryAgain,
            style: StyleType.bodMed,
          ),
        ),
      ],
    );
  }

  void _showNotSetupDialog(BuildContext context, String message) {
    final localize = textLocalizer(context);
    AppDialog.showCustomDialog(
      context,
      title: AppText(
        text: textLocalizer(context).authenticationFailed,
        style: StyleType.headMed,
        textAlign: TextAlign.center,
      ),
      content: AppText(text: message),
      actions: <Widget>[
        AppButton(
          height: 48,
          label: localize.tryAgain,
          onPressed: () {
            context.pop();
            _authenticate();
          },
        ),
        Gap.vertical(8),
        AppButton(
          height: 48,
          label: localize.setUp,
          onPressed: () {
            _openBiometricSettings();
            context.pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final isDarkMode = context.isDarkModeSetting;
    return Scaffold(
      backgroundColor: const Color(0xFF39693b),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            getPngAsset(
              logo,
              width: 150,
              height: 150,
              color: isDarkMode ? context.color.onPrimary : null,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppButton(
                label: localize.authenticate,
                backgroundColor: const Color(0xffa5d395),
                onPressed: _authenticate,
                labelColor: Colors.black,
                suffixIcon: getPngAsset(
                  identityPng,
                  width: 50,
                  color: isDarkMode ? context.color.onPrimary : null,
                ),
              ),
            ),
            Gap.vertical(100),
          ],
        ),
      ),
    );
  }
}
