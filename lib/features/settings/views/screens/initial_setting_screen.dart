import 'dart:async';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class InitialSettingScreen extends StatefulWidget {
  const InitialSettingScreen({super.key});

  @override
  State<InitialSettingScreen> createState() => _InitialSettingScreenState();
}

class _InitialSettingScreenState extends State<InitialSettingScreen>
    with WidgetsBindingObserver {
  // late StreamSubscription<List<PurchaseDetails>> _iapSubscription;
  final _nameController = TextEditingController();
  bool _notificationsEnabled = false;
  AppLifecycleState? _appLifecycleState;
  bool canAuthenticate = false;

  @override
  void dispose() {
    _nameController.dispose();
    // _iapSubscription.cancel();
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestPermissions();
    _checkAuth();

    // _getUserData();
    // _initializeIAP();
  }

  Future<void> _getUserData() async {
    final userId = await context.read<PreferenceCubit>().getUserUid();
    if (userId != null) {
      if (!mounted) return;

      await context.read<UserFirestoreCubit>().getUserFirestore();
    } else {
      if (!mounted) return;
      context.read<SettingBloc>().add(GetUserSettingEvent());
    }
  }

  void _onSuccessAuth(UserIntelli? user) {
    if (user != null) {
      context.read<SettingBloc>()
        ..add(SetUserIsLoggedIn(isLoggedIn: true))
        ..add(SetUserName(user.name))
        ..add(SetUserEmail(user.email))
        ..add(SetUserUidEvent(user.uid))
        ..add(SetUserIsPremiumUser(isPremiumUser: user.premium ?? false))
        ..add(GetUserSettingEvent());
    } else {
      context.read<SettingBloc>().add(GetUserSettingEvent());
    }
  }

  Future<void> _checkAuth() async {
    final auth = LocalAuthentication();
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final isCanAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    setState(() {
      canAuthenticate = isCanAuthenticate;
    });
  }

  Future<bool> _areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      return granted;
    }
    return false;
  }

  Future<void> _isAndroidPermissionGranted() async {
    final granted = await _areNotificationsEnabled();

    setState(() {
      _notificationsEnabled = granted;
    });

    if (granted) {
      if (_notificationsEnabled) {
        _setNotificationSetting(value: true);
        await _setScheduleNotification();
      } else {
        _setNotificationSetting(value: false);
        await cancelAllNotifications();
      }
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final enable = await _areNotificationsEnabled();

      if (!enable) {
        final grantedNotificationPermission =
            await androidImplementation?.requestNotificationsPermission();

        setState(() {
          _notificationsEnabled = grantedNotificationPermission ?? false;
        });

        if (_notificationsEnabled) {
          _setNotificationSetting(value: true);
          await _setScheduleNotification();
        } else {
          _setNotificationSetting(value: false);
          await cancelAllNotifications();
        }
      }
    }
  }

  void _setNotificationSetting({required bool value}) {
    context.read<SettingBloc>().add(
          NotificationChange(value: value),
        );
  }

  void _openAndroidNotificationSetting() {
    if (Platform.isAndroid) {
      const AndroidIntent(
        action: 'android.settings.APP_NOTIFICATION_SETTINGS',
        arguments: <String, dynamic>{
          'android.provider.extra.APP_PACKAGE':
              'com.porseatechnology.budgetIntelli',
        },
      ).launch();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;

    if (_appLifecycleState == AppLifecycleState.resumed) {
      _isAndroidPermissionGranted();
    }
  }

  // void _initializeIAP() {
  //   print('hit iap init');
  //   final purchaseUpdated = InAppPurchase.instance.purchaseStream;
  //
  //   _iapSubscription = purchaseUpdated.listen(
  //     (purchaseDetailsList) {
  //       context.read<UserFirestoreCubit>().listenToPurchaseUpdated(
  //             purchaseDetailsList,
  //           );
  //     },
  //     onDone: () {
  //       print('on done iap');
  //       _iapSubscription.cancel();
  //     },
  //     onError: (error) {
  //       print('on error iap');
  //       _iapSubscription.cancel();
  //     },
  //   );
  // }

  // void _showPremiumModalBottom(UserIntelli? user) {
  //   final statusBarHeight = MediaQuery.of(context).padding.top;
  //   showModalBottomSheet<void>(
  //     context: context,
  //     isScrollControlled: true,
  //     constraints: BoxConstraints(
  //       maxHeight: MediaQuery.sizeOf(context).height - statusBarHeight,
  //     ),
  //     builder: (context) {
  //       return PremiumModal(
  //         user: user,
  //       );
  //     },
  //   );
  // }

  Future<void> _setScheduleNotification() async {
    final localize = textLocalizer(context);

    await scheduleDailyNotification(
      hour: 6,
      title: localize.goodMorning,
      body: localize.startYourDay,
    );

    await scheduleDailyNotification(
      hour: 13,
      title: localize.helloHowAreYou,
      body: localize.timeToTakeABreak,
    );

    await scheduleDailyNotification(
      hour: 20,
      title: localize.goodNightWiseTracker,
      body: localize.beforeSleeping,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: getEdgeInsetsAll(16),
        child: Center(
          child: BlocBuilder<SettingBloc, SettingState>(
            builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              var themeMode = '';
              if (state.themeMode == ThemeMode.dark) {
                themeMode = localize.darkMode;
              } else if (state.themeMode == ThemeMode.light) {
                themeMode = localize.lightMode;
              }

              final bloc = context.read<SettingBloc>();

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // AppText(
                  //   text: localize.welcomeToBudgetIntelli,
                  //   style: StyleType.headLg,
                  //   textAlign: TextAlign.center,
                  // ).animate().fadeIn().scale().move(
                  //       delay: 300.ms,
                  //       duration: 600.ms,
                  //     ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: getPngAsset(
                      budgetIntelliPng,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ).animate().fadeIn().scale().move(
                        delay: 300.ms,
                        duration: 600.ms,
                      ),
                  Gap.vertical(32),
                  AppText(
                    text: localize.welcomeToBudgetIntelli,
                    style: StyleType.headMed,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn().scale().move(
                        delay: 300.ms,
                        duration: 600.ms,
                      ),
                  Gap.vertical(32),
                  AppGlass(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.medium16(
                              text: themeMode,
                            ),
                            Switch(
                              value: state.themeMode == ThemeMode.dark,
                              onChanged: (value) {
                                final val = !state.isDarkMode;

                                if (val) {
                                  bloc.add(
                                    ThemeModeChange(IntelliThemeMode.dark),
                                  );
                                } else {
                                  bloc.add(
                                    ThemeModeChange(IntelliThemeMode.light),
                                  );
                                }
                              },
                              activeColor: context.color.primary,
                            ),
                          ],
                        ),
                        if (canAuthenticate)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText.medium16(
                                text: localize.biometricOrPatternLogin,
                              ),
                              Switch(
                                value: state.useBiometrics == true,
                                onChanged: (value) {
                                  final val = !state.useBiometrics;

                                  bloc.add(
                                    BiometricSettingChange(value: val),
                                  );
                                },
                                activeColor: context.color.primary,
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.medium16(
                              text: localize.notification,
                            ),
                            Switch(
                              value: state.notificationEnable,
                              onChanged: (value) async {
                                final val = !state.notificationEnable;

                                // setState(() {
                                //   _notificationsEnabled = val;
                                // });

                                if (val) {
                                  if (_notificationsEnabled) {
                                    _setNotificationSetting(value: val);
                                    await _setScheduleNotification();
                                  } else {
                                    _setNotificationSetting(value: false);

                                    final isEnable =
                                        await _areNotificationsEnabled();
                                    if (isEnable == true) {
                                      await _setScheduleNotification();
                                    } else {
                                      _openAndroidNotificationSetting();
                                    }
                                  }
                                } else {
                                  _setNotificationSetting(value: false);
                                  await cancelAllNotifications();
                                }
                              },
                              activeColor: context.color.primary,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.medium16(
                              text: localize.language,
                            ),
                            DropdownButton<String>(
                              underline: const SizedBox(),
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.zero,
                              value: state.selectedLanguage == Language.english
                                  ? 'English'
                                  : 'Indonesia',
                              onChanged: (String? value) {
                                if (value != null) {
                                  if (value == 'Indonesia') {
                                    bloc.add(
                                      LanguageChange(Language.indonesia),
                                    );
                                  } else {
                                    bloc.add(
                                      LanguageChange(Language.english),
                                    );
                                  }
                                }
                              },
                              items: <String>['English', 'Indonesia']
                                  .map<DropdownMenuItem<String>>(
                                    (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: AppText.medium16(
                                        text: value,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.medium16(
                              text: localize.currency,
                            ),
                            DropdownButton<CurrencyModel>(
                              underline: const SizedBox(),
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.zero,
                              value: state.currency,
                              onChanged: (CurrencyModel? value) {
                                if (value != null) {
                                  bloc.add(CurrencyChange(value));
                                }
                              },
                              items: WorldCurrency.currencyList
                                  .map<DropdownMenuItem<CurrencyModel>>(
                                    (CurrencyModel value) =>
                                        DropdownMenuItem<CurrencyModel>(
                                      value: value,
                                      child: AppText.medium16(
                                        text: value.name,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Gap.vertical(32),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: AppButton.noWidth(
                  //         label: localize.signInLabel,
                  //         onPressed: () {
                  //           context.push(RouteName.signInInitial);
                  //         },
                  //       ),
                  //     ),
                  // Gap.horizontal(16),
                  // Expanded(
                  //   child: AppButton.noWidth(
                  //     label: localize.buyPremium,
                  //     onPressed: () {
                  //       _showPremiumModalBottom(state.user);
                  //     },
                  //   ),
                  // ),
                  // ],
                  // ),
                  Gap.vertical(20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: context.color.surface,
                      side: BorderSide(
                        color: context.color.onSurface,
                      ),
                      minimumSize: Size(double.infinity, 58.h),
                    ),
                    onPressed: () async {
                      // final notificationServices = NotificationServices();
                      // if (notificationEnable) {
                      //   await notificationServices
                      //       .scheduleNotifications(context);
                      // } else {
                      //   await notificationServices.cancelNotification();
                      // }
                      context.read<SettingBloc>()
                        ..add(
                          SetUserAlreadySetInitialSetting(
                            alreadySetInitialSetting: true,
                          ),
                        )
                        ..add(
                          SetUserContinueWithoutLogin(
                            continueWithoutLogin: true,
                          ),
                        );
                      context.go(MyRoute.initialCreateBudgetPlan);
                    },
                    child: AppText(
                      text: localize.startBudgeting,
                      style: StyleType.bodLg,
                      color: context.color.onSurface,
                    ),
                  )
                      .animate()
                      .fadeIn() // uses `Animate.defaultDuration`
                      .scale() // inherits duration from fadeIn
                      .move(
                        delay: 300.ms,
                        duration: 600.ms,
                      ),
                  Gap.vertical(10),
                  if (!state.hideFinancialTracker)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: context.color.surface,
                        side: BorderSide(
                          color: context.color.onSurface,
                        ),
                        minimumSize: Size(double.infinity, 58.h),
                      ),
                      onPressed: () async {
                        context.read<SettingBloc>()
                          ..add(
                            SetUserAlreadySetInitialSetting(
                              alreadySetInitialSetting: true,
                            ),
                          )
                          ..add(
                            SetUserContinueWithoutLogin(
                              continueWithoutLogin: true,
                            ),
                          )
                          ..add(
                            SetOnlyFinancialTrackerChange(
                              value: true,
                            ),
                          );
                        context.go(MyRoute.financialDashboardTracker);
                      },
                      child: AppText(
                        text: localize.startFinancialTracking,
                        style: StyleType.bodLg,
                        color: context.color.onSurface,
                      ),
                    ).animate().fadeIn().scale().move(
                          delay: 300.ms,
                          duration: 600.ms,
                        ),
                  // Gap.vertical(20),
                  // OutlinedButton(
                  //   style: OutlinedButton.styleFrom(
                  //     backgroundColor: context.color.surface,
                  //     side: BorderSide(
                  //       color: context.color.onSurface,
                  //     ),
                  //     minimumSize: Size(double.infinity, 58.h),
                  //   ),
                  //   onPressed: () {},
                  //   child: AppText(
                  //     text: localize.setPin,
                  //     style: StyleType.bodLg,
                  //     color: context.color.onSurface,
                  //   ),
                  // ).animate().fadeIn().scale().move(
                  //       delay: 300.ms,
                  //       duration: 600.ms,
                  //     ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

// void _setData() {
//   final name = _nameController.text;
//   if (name.isNotEmpty) {
//     context.read<SettingBloc>()
//       ..add(SetUserName(name))
//       ..add(
//         SetUserAlreadySetInitialSetting(alreadySetInitialSetting: true),
//       );
//
//     context.push(
//       RouteName.initialCreateBudgetPlan,
//     );
//   } else {
//     AppToast.showToastError(
//       context,
//       'Please fill your name first',
//     );
//   }
// }
}
