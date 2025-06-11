import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinancialTrackerDashboardAppbar extends StatefulWidget {
  const FinancialTrackerDashboardAppbar({
    super.key,
  });

  @override
  State<FinancialTrackerDashboardAppbar> createState() =>
      _FinancialTrackerDashboardAppbarState();
}

class _FinancialTrackerDashboardAppbarState
    extends State<FinancialTrackerDashboardAppbar>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            getSvgAsset(
              chevronDown,
            ),
            AppText(
              text: 'Buku Bawaan',
              style: StyleType.bodMd,
              color: context.color.onSurface,
            ),
          ],
        ),
      ],
    );
  }

  void _showCalculator() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
      builder: (context) {
        return const TransactionCalculatorBottomSheet();
      },
    );
  }

  void _getAccounts() {
    context.read<AccountBloc>().add(GetAccountsEvent());
  }
}
