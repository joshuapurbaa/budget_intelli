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
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Menutup drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Menutup drawer
              },
            ),
          ],
        ),
      ),
      body: const CustomScrollView(
        slivers: [
          FinancialTrackerDashboardAppbar(),
          FinancialTrackerDashboardBody(),
        ],
      ),
    );
  }
}
