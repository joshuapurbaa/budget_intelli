import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinancialTrackerDashboard extends StatefulWidget {
  const FinancialTrackerDashboard({super.key});

  @override
  State<FinancialTrackerDashboard> createState() =>
      _FinancialTrackerDashboardState();
}

class _FinancialTrackerDashboardState extends State<FinancialTrackerDashboard> {
  @override
  void initState() {
    super.initState();
    _getAllFinancialTransactionByMonthAndYearDb();
  }

  void _getAllFinancialTransactionByMonthAndYearDb() {
    final monthNow = DateTime.now().month;
    String? monthStr;
    if (monthNow < 10) {
      monthStr = '0$monthNow';
    } else {
      monthStr = monthNow.toString();
    }
    context
        .read<FinancialDashboardCubit>()
        .getAllFinancialTransactionByMonthAndYear(
          context,
          monthStr: monthStr,
        );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: DrawerFinancialTracker(),
      body: CustomScrollView(
        slivers: [
          FinancialTrackerDashboardAppbar(),
          FinancialTrackerDashboardBody(),
        ],
      ),
    );
  }
}

