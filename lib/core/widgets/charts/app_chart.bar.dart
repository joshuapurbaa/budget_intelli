import 'package:budget_intelli/core/widgets/charts/bar_chart_daily.dart';
import 'package:budget_intelli/core/widgets/charts/bar_chart_monthly.dart';
import 'package:budget_intelli/core/widgets/charts/bar_chart_yearly.dart';
import 'package:budget_intelli/features/category/view/controllers/insight/insight_cubit.dart';
import 'package:budget_intelli/features/settings/controller/settings_bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppChartBar extends StatefulWidget {
  const AppChartBar({super.key});

  @override
  State<StatefulWidget> createState() => AppChartBarState();
}

class AppChartBarState extends State<AppChartBar> {
  @override
  void initState() {
    super.initState();
    context.read<SettingBloc>().add(GetLanguageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        final selectedLanguage = state.selectedLanguage;
        return BlocBuilder<InsightCubit, InsightState>(
          builder: (context, state) {
            final frequency = state.selectedFrequency;
            final dailyTransactions = state.dailyTransactions;
            final monthlyTransactions = state.monthlyTransactions;
            final yearlyTransactions = state.yearlyTransactions;

            final daily = frequency == 'Daily';
            final monthly = frequency == 'Monthly';
            final yearly = frequency == 'Yearly';

            var dailyAmounts = <int>[];
            var monthlyAmounts = <int>[];

            if (dailyTransactions.isNotEmpty) {
              dailyAmounts = dailyTransactions.values.toList();
            } else {
              dailyAmounts = [0, 0, 0, 0, 0, 0, 0];
            }

            if (monthlyTransactions.isNotEmpty) {
              monthlyAmounts = monthlyTransactions.values.toList();
            } else {
              monthlyAmounts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            }

            if (daily) {
              return AspectRatio(
                aspectRatio: 2.2,
                child: BarChartDaily(
                  dailyAmounts: dailyAmounts,
                  selectedLanguage: selectedLanguage,
                ),
              );
            } else if (monthly) {
              return AspectRatio(
                aspectRatio: 2.2,
                child: BarChartMonthly(
                  monthlyAmounts: monthlyAmounts,
                ),
              );
            } else if (yearly) {
              return AspectRatio(
                aspectRatio: 2.2,
                child: BarChartYearly(
                  yearlyTransactions: yearlyTransactions,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}
