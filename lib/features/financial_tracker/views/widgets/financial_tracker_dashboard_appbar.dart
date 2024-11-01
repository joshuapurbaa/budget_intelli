import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FinancialTrackerDashboardAppbar extends StatefulWidget {
  const FinancialTrackerDashboardAppbar({
    super.key,
  });

  @override
  State<FinancialTrackerDashboardAppbar> createState() =>
      _FinancialTrackerDashboardAppbarState();
}

class _FinancialTrackerDashboardAppbarState
    extends State<FinancialTrackerDashboardAppbar> {
  void _showCalculator() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const CalculatorBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      title: Row(
        children: [
          const Spacer(),
          Row(
            children: [
              Gap.vertical(10),
              const AppText(
                text: r'$35,000.00',
                style: StyleType.bodLg,
              ),
              Gap.horizontal(5),
              Icon(
                CupertinoIcons.chevron_down,
                color: context.color.onSurface,
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: _showCalculator,
            child: getSvgPicture(
              editSvg,
              color: context.color.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
