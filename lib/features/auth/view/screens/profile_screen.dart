import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/auth/view/widgets/user_avatar.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/settings/models/pdf_content_model.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  bool _notificationsEnabled = false;
  AppLifecycleState? _appLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAuth();
    _requestPermissions();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
    if (Platform.isIOS || Platform.isMacOS) {
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

  bool canAuthenticate = false;

  Future<void> _checkAuth() async {
    final auth = LocalAuthentication();
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final isCanAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    setState(() {
      canAuthenticate = isCanAuthenticate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final user = context.watch<SettingBloc>().state.user;

    return Scaffold(
      body: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, settingState) {
          final bloc = context.read<SettingBloc>();
          final userIntelli = user;

          final darkMode = settingState.themeMode == ThemeMode.dark;
          final english = settingState.selectedLanguage == Language.english;

          final imageUrl = userIntelli?.imageUrl;
          final premiumUser = userIntelli?.premium ?? false;

          String? firstChar;
          String? name;
          String? email;

          if (userIntelli?.name != null) {
            name = userIntelli?.name ?? '-';
            firstChar = name[0];
          } else {
            name = '-';
            firstChar = '-';
          }

          if (userIntelli?.email != null) {
            email = userIntelli?.email ?? '-';
          } else {
            email = '-';
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: context.color.surface,
                pinned: true,
                title: AppText(
                  style: StyleType.headLg,
                  text: localize.profile,
                ),
                centerTitle: true,
                floating: true,
                snap: true,
                expandedHeight: 210.h,
                flexibleSpace: FlexibleSpaceBar(
                  background: UserAvar(
                    imageUrl: imageUrl ?? '-',
                    firstChar: firstChar,
                    name: name,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    Padding(
                      padding: getEdgeInsetsAll(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RowText(
                            left: 'Email',
                            right: email,
                          ),
                          Gap.vertical(10),
                          RowText(
                            left: localize.profileAccountType,
                            right: premiumUser ? 'Premium' : 'Free',
                          ),
                          Gap.vertical(10),
                          const AppDivider(),
                          Gap.vertical(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText.medium14(
                                text: localize.darkMode,
                              ),
                              Switch(
                                value: darkMode,
                                onChanged: (value) {
                                  final val = !settingState.isDarkMode;

                                  if (val) {
                                    bloc.add(
                                      ThemeModeChange(
                                        IntelliThemeMode.dark,
                                      ),
                                    );
                                  } else {
                                    bloc.add(
                                      ThemeModeChange(
                                        IntelliThemeMode.light,
                                      ),
                                    );
                                  }
                                },
                                activeColor: context.color.primary,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText.medium14(
                                text: localize.notification,
                              ),
                              Switch(
                                value: settingState.notificationEnable,
                                onChanged: (value) async {
                                  final val = !settingState.notificationEnable;

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
                          if (canAuthenticate)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText.medium16(
                                  text: localize.biometricOrPatternLogin,
                                ),
                                Switch(
                                  value: settingState.useBiometrics == true,
                                  onChanged: (value) {
                                    final val = !settingState.useBiometrics;

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
                              AppText.medium14(
                                text: localize.language,
                              ),
                              DropdownButton<String>(
                                underline: const SizedBox(),
                                alignment: Alignment.bottomLeft,
                                padding: EdgeInsets.zero,
                                value: english ? 'English' : 'Indonesia',
                                onChanged: (String? value) {
                                  if (value != null) {
                                    if (value == 'English') {
                                      bloc.add(
                                        LanguageChange(Language.english),
                                      );
                                    } else {
                                      bloc.add(
                                        LanguageChange(
                                          Language.indonesia,
                                        ),
                                      );
                                    }
                                  }
                                },
                                items: <String>['English', 'Indonesia']
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: AppText.medium14(
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
                              AppText.medium14(
                                text: localize.currency,
                              ),
                              DropdownButton<CurrencyModel>(
                                underline: const SizedBox(),
                                alignment: Alignment.bottomLeft,
                                padding: EdgeInsets.zero,
                                value: settingState.currency,
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
                                        child: AppText.medium14(
                                          text: value.name,
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
                              AppText.medium14(
                                text: localize.exportData,
                              ),
                              IconButton(
                                onPressed: () {
                                  final budgetBlocState =
                                      context.read<BudgetBloc>().state;

                                  if (budgetBlocState is GetBudgetsLoaded) {
                                    final budget = budgetBlocState.budget;
                                    final transactions = budgetBlocState
                                        .itemCategoryTransactionsByBudgetId;
                                    final totalActualIncome =
                                        budgetBlocState.totalActualIncome;
                                    final totalActualExpense =
                                        budgetBlocState.totalActualExpense;
                                    if (budget != null) {
                                      final pdfContentList =
                                          <PdfContentModel>[];
                                      final itemCategories =
                                          <ItemCategoryHistory>[];

                                      final groupCategories =
                                          budget.groupCategories ?? [];

                                      for (final group in groupCategories) {
                                        itemCategories.addAll(
                                          group.itemCategoryHistories,
                                        );
                                      }
                                      final incomeCategories = itemCategories
                                          .where((e) => e.type == 'income');
                                      final expenseCategories = itemCategories
                                          .where((e) => e.type == 'expense');
                                      // final incomeTransactions = transactions.where((e) => e.type == 'income');
                                      // final expenseTransactions = transactions.where((e) => e.type == 'expense');

                                      for (final item in itemCategories) {
                                        final actualAmount = transactions
                                            .where(
                                              (element) =>
                                                  element.itemHistoId ==
                                                  item.id,
                                            )
                                            .fold<double>(
                                              0,
                                              (previousValue, element) =>
                                                  previousValue +
                                                  element.amount,
                                            );

                                        final pdfContent = PdfContentModel(
                                          categoryName: item.name,
                                          type: item.type,
                                          plannedAmount: NumberFormatter
                                              .formatToMoneyDouble(
                                            context,
                                            item.amount,
                                          ),
                                          actualAmount: NumberFormatter
                                              .formatToMoneyDouble(
                                            context,
                                            actualAmount,
                                          ),
                                        );

                                        pdfContentList.add(pdfContent);
                                      }
                                      final startDate = budget.startDate;
                                      final endDate = budget.endDate;
                                      final dateRanges = [startDate, endDate];
                                      final dateRangeStr = formatDateRangeStr(
                                        dateRanges,
                                        context,
                                      );
                                      final language =
                                          settingState.selectedLanguage.text;
                                      const summaryDescriptionEn =
                                          'On this report, you will see the summary of your budget plan and the actual amount of your income and expense.';
                                      const summaryDescriptionID =
                                          'Pada laporan ini, Anda akan melihat ringkasan dari rencana anggaran Anda serta jumlah aktual dari pendapatan dan pengeluaran Anda.';

                                      context.read<SettingBloc>().add(
                                            ExportDataEvent(
                                              pdfContentList: pdfContentList,
                                              periodString:
                                                  '${localize.periodFieldLabel}: $dateRangeStr',
                                              language: language,
                                              summaryDescription:
                                                  language == 'English'
                                                      ? summaryDescriptionEn
                                                      : summaryDescriptionID,
                                              totalPlannedAmountIncome:
                                                  NumberFormatter
                                                      .formatToMoneyDouble(
                                                context,
                                                incomeCategories.fold<double>(
                                                  0,
                                                  (previousValue, element) =>
                                                      previousValue +
                                                      element.amount,
                                                ),
                                              ),
                                              totalActualAmountIncome:
                                                  NumberFormatter
                                                      .formatToMoneyDouble(
                                                context,
                                                totalActualIncome,
                                              ),
                                              totalPlannedAmountExpense:
                                                  NumberFormatter
                                                      .formatToMoneyDouble(
                                                context,
                                                expenseCategories.fold<double>(
                                                  0,
                                                  (previousValue, element) =>
                                                      previousValue +
                                                      element.amount,
                                                ),
                                              ),
                                              totalActualAmountExpense:
                                                  NumberFormatter
                                                      .formatToMoneyDouble(
                                                context,
                                                totalActualExpense,
                                              ),
                                            ),
                                          );
                                    }
                                  }
                                },
                                icon: getPngAsset(
                                  exportFilePng,
                                  color: context.color.onSurface,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText.medium14(
                                text: localize.requestFeature,
                              ),
                              IconButton(
                                onPressed: () {
                                  sendEmail(
                                    'porseatechnology@gmail.com',
                                    localize.requestFeature,
                                    'Hi Budget Intelli,\n\n',
                                  );
                                },
                                icon: const Icon(
                                  Icons.email_outlined,
                                ),
                              ),
                            ],
                          ),
                          if (settingState.isLoggedIn) ...[
                            Gap.vertical(16),
                            BlocListener<AuthBloc, AuthState>(
                              listener: (context, state) {
                                if (state is SignOutSuccess) {
                                  context.go(MyRoute.signInInitial);
                                }
                              },
                              child: GestureDetector(
                                onTap: () {
                                  AppDialog.showConfirmationDialog(
                                    context,
                                    title: localize.areYouSure,
                                    onConfirm: () {
                                      context.pop();
                                      context.read<AuthBloc>().add(
                                            SignOutEvent(),
                                          );
                                    },
                                    onCancel: () {
                                      context.pop();
                                    },
                                  );
                                },
                                child: AppText.color(
                                  text: localize.signOut,
                                  color: AppColor.red,
                                  style: StyleType.bodLg,
                                ),
                              ),
                            ),
                          ],
                          if (!premiumUser) ...[
                            Gap.vertical(32),
                            // AppButton(
                            //   label: localize.buyPremium,
                            //   onPressed: () {
                            //     _showPremiumModalBottom(userIntelli);
                            //   },
                            // ),
                            // Gap.vertical(16),
                            AdWidgetRepository(
                              height: 50,
                              user: userIntelli,
                              child: Container(
                                color: context.color.surface,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;

    if (_appLifecycleState == AppLifecycleState.resumed) {
      _isAndroidPermissionGranted();
    }
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

  void _setNotificationSetting({required bool value}) {
    context.read<SettingBloc>().add(
          NotificationChange(value: value),
        );
  }

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

  Future<void> sendEmail(
    String toEmail,
    String subject,
    String body,
  ) async {
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: toEmail,
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': body,
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(
        emailLaunchUri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  // String _encodeQueryParameters(Map<String, String> params) {
  //   return params.entries
  //       .map(
  //         (MapEntry<String, String> e) =>
  //             '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
  //       )
  //       .join('&');
  // }
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}
