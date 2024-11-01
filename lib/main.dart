import 'package:budget_intelli/budget_intelli.dart';
import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/core/global_controller/app_size/app_size_cubit.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/ai_assistant/view/controller/chat/chat_cubit.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/category_barrel.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:budget_intelli/features/net_worth/net_worth_barrel.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:budget_intelli/features/schedule_payment/views/controller/repitition/repitition_cubit.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:budget_intelli/features/transactions/transactions_barrel.dart';
import 'package:budget_intelli/init_dependencies.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await configureLocalTimeZone();

  final notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
  }

  const initializationSettingsAndroid =
      AndroidInitializationSettings('icon_budget_intelli');

  final darwinNotificationCategories = <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    ),
  ];

  final initializationSettingsDarwin = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );

  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);

        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  await initDependencies();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider<SchedulePaymentBloc>(
          create: (_) => serviceLocator<SchedulePaymentBloc>(),
        ),
        BlocProvider<UploadImageBloc>(
          create: (_) => UploadImageBloc(),
        ),
        BlocProvider<BoxCategoryCubit>(
          create: (_) => BoxCategoryCubit(),
        ),
        BlocProvider<BoxCalendarCubit>(
          create: (_) => BoxCalendarCubit(),
        ),
        BlocProvider<UserFirestoreCubit>(
          create: (_) => serviceLocator<UserFirestoreCubit>(),
        ),
        BlocProvider<GetSchedulePaymentCubit>(
          create: (_) => serviceLocator<GetSchedulePaymentCubit>(),
        ),
        BlocProvider<CudSchedulePaymentBloc>(
          create: (_) => serviceLocator<CudSchedulePaymentBloc>(),
        ),
        BlocProvider<ChatCubit>(
          create: (_) => serviceLocator<ChatCubit>(),
        ),
        BlocProvider<BoxCalculatorCubit>(
          create: (_) => BoxCalculatorCubit(),
        ),
        BlocProvider<RepititionCubit>(
          create: (_) => RepititionCubit(),
        ),
        BlocProvider<SettingBloc>(
          create: (_) => serviceLocator<SettingBloc>(),
        ),
        BlocProvider<BudgetFormBloc>(
          create: (_) => serviceLocator<BudgetFormBloc>(),
        ),
        BlocProvider<BudgetBloc>(
          create: (_) => serviceLocator<BudgetBloc>(),
        ),
        BlocProvider<AppSizeCubit>(
          create: (_) => AppSizeCubit(),
        ),
        BlocProvider<CategoryCubit>(
          create: (_) => serviceLocator<CategoryCubit>(),
        ),
        BlocProvider<TransactionsCubit>(
          create: (_) => serviceLocator<TransactionsCubit>(),
        ),
        BlocProvider<BudgetsCubit>(
          create: (_) => serviceLocator<BudgetsCubit>(),
        ),
        BlocProvider<TrackingCubit>(
          create: (_) => serviceLocator<TrackingCubit>(),
        ),
        BlocProvider<SearchTransactionCubit>(
          create: (_) => SearchTransactionCubit(),
        ),
        BlocProvider<InsightCubit>(
          create: (_) => serviceLocator<InsightCubit>(),
        ),
        BlocProvider<NetWorthBloc>(
          create: (_) => serviceLocator<NetWorthBloc>(),
        ),
        BlocProvider<AccountBloc>(
          create: (_) => serviceLocator<AccountBloc>(),
        ),
        BlocProvider<BudgetFirestoreCubit>(
          create: (_) => serviceLocator<BudgetFirestoreCubit>(),
        ),
        BlocProvider<PreferenceCubit>(
          create: (_) => serviceLocator<PreferenceCubit>(),
        ),
        BlocProvider<PromptCubit>(
          create: (_) => serviceLocator<PromptCubit>(),
        ),
        BlocProvider<PromptAnalysisCubit>(
          create: (_) => serviceLocator<PromptAnalysisCubit>(),
        ),
        BlocProvider<SchedulePaymentDbBloc>(
          create: (_) => serviceLocator<SchedulePaymentDbBloc>(),
        ),
        BlocProvider<GoalDatabaseBloc>(
          create: (_) => serviceLocator<GoalDatabaseBloc>(),
        ),
        BlocProvider<MyPortfolioDbBloc>(
          create: (_) => serviceLocator<MyPortfolioDbBloc>(),
        ),
        BlocProvider<AppBoxCalendarCubit>(
          create: (_) => AppBoxCalendarCubit(),
        ),
        BlocProvider<FinancialCalculatorCubit>(
          create: (_) => FinancialCalculatorCubit(),
        ),
        BlocProvider<FinancialDashboardCubit>(
          create: (_) => FinancialDashboardCubit(),
        ),
        BlocProvider<FinancialCategoryBloc>(
          create: (_) => serviceLocator<FinancialCategoryBloc>(),
        ),
        BlocProvider<FinancialCategoryHistoryBloc>(
          create: (_) => serviceLocator<FinancialCategoryHistoryBloc>(),
        ),
      ],
      child: const BudgetIntelli(),
    ),
  );
}
