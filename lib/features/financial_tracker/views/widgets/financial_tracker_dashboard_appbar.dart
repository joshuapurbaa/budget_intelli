import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
        const Spacer(),
        BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            return Row(
              children: [
                Gap.vertical(10),
                AppText(
                  text: NumberFormatter.formatToMoneyDouble(
                    context,
                    state.totalBalance ?? 0.0,
                  ),
                  style: StyleType.bodLg,
                ),
                Gap.horizontal(5),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      MyRoute.accountScreenFinancialTracker.noSlashes(),
                    );
                  },
                  child: Icon(
                    CupertinoIcons.chevron_down,
                    color: context.color.onSurface,
                  ),
                ),
              ],
            );
          },
        ),
        const Spacer(),
        GestureDetector(
          onTap: _showCalculator,
          child: getSvgAsset(
            editSvg,
            color: context.color.onSurface,
          ),
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
        return const CalculatorBottomSheet();
      },
    );
  }

  void _getAccounts() {
    context.read<AccountBloc>().add(GetAccountsEvent());
  }
}
