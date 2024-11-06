import 'dart:math';

import 'package:budget_intelli/core/core.dart';
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
  double value = 0;

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
      backgroundColor: context.color.primaryContainer,
      body: Stack(
        children: [
          DrawerFinancialTracker(),
          TweenAnimationBuilder(
            curve: Curves.easeInOut,
            tween: Tween<double>(begin: 0, end: value),
            duration: const Duration(milliseconds: 500),
            builder: (_, double val, __) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, 200 * val)
                  ..rotateY((pi / 6) * val),
                child: Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: FinancialTrackerDashboardAppbar(),
                    leading: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        setState(() {
                          value == 0 ? value = 1 : value = 0;
                        });
                      },
                    ),
                  ),
                  body: CustomScrollView(
                    slivers: [
                      // FinancialTrackerDashboardAppbar(),
                      FinancialTrackerDashboardBody(),
                    ],
                  ),
                ),
              );
            },
          ),
          GestureDetector(
            onHorizontalDragUpdate: (e) {
              if (e.delta.dx > 0) {
                setState(() {
                  value = 1;
                });
              } else {
                setState(() {
                  value = 0;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

class DrawerFinancialTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.color.primaryContainer,
              context.color.primaryContainer,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 45,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Financial Tracker"),
                  ),
                ],
              ),
            ),
            const ListTile(
              title: Text("Dashboard"),
              leading: Icon(Icons.dashboard),
            ),
            const ListTile(
              title: Text("Transactions"),
              leading: Icon(Icons.account_balance_wallet),
            ),
            const ListTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
