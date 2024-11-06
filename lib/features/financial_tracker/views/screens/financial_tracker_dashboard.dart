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
    final halfWidth = (MediaQuery.of(context).size.width / 2).toInt();
    return Scaffold(
      backgroundColor: context.color.primaryContainer,
      body: Stack(
        children: [
          const DrawerFinancialTracker(),
          TweenAnimationBuilder(
            curve: Curves.easeInOut,
            tween: Tween<double>(begin: 0, end: value),
            duration: const Duration(milliseconds: 500),
            builder: (_, double val, __) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, halfWidth * val)
                  ..rotateY((pi / 6) * val),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(value == 1 ? 30 : 0),
                    bottomLeft: Radius.circular(value == 1 ? 30 : 0),
                  ),
                  child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: const FinancialTrackerDashboardAppbar(),
                      leading: IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          setState(() {
                            value == 0 ? value = 1 : value = 0;
                          });
                        },
                      ),
                    ),
                    body: const CustomScrollView(
                      slivers: [
                        FinancialTrackerDashboardBody(),
                      ],
                    ),
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
