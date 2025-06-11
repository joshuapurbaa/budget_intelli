import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/core/l10n/app_localizations.dart';
import 'package:budget_intelli/core/theme/material_theme.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetIntelli extends StatefulWidget {
  const BudgetIntelli({super.key});

  @override
  State<BudgetIntelli> createState() => _BudgetIntelliState();
}

class _BudgetIntelliState extends State<BudgetIntelli> {
  @override
  void initState() {
    super.initState();
    // NotificationServices().setListener();

    // context.read<AuthBloc>().add(GetCurrentUserSessionEvent());
    context.read<SettingBloc>().add(GetUserSettingEvent());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            return MaterialApp.router(
              locale: state.selectedLanguage.value,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
              title: 'Budget Intelli',
              theme: MaterialTheme(AppTextStyle.textThemeLightMode).light(),
              darkTheme: MaterialTheme(AppTextStyle.textThemeDarkMode).dark(),
              themeMode: state.themeMode,
              routeInformationParser: AppRoute.router.routeInformationParser,
              routeInformationProvider:
                  AppRoute.router.routeInformationProvider,
              routerDelegate: AppRoute.router.routerDelegate,
              backButtonDispatcher: AppRoute.router.backButtonDispatcher,
            );
          },
        );
      },
    );
  }
}
