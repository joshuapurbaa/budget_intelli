import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedSummaryDashboardFilter extends StatefulWidget {
  const AnimatedSummaryDashboardFilter({
    required this.state,
    super.key,
  });

  final FinancialDashboardState state;

  @override
  State<AnimatedSummaryDashboardFilter> createState() =>
      _AnimatedSummaryDashboardFilterState();
}

class _AnimatedSummaryDashboardFilterState
    extends State<AnimatedSummaryDashboardFilter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedSummaryDashboardFilter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.state.filterBy != widget.state.filterBy) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterBy = widget.state.filterBy;
    final localize = textLocalizer(context);
    final currency = context.watch<SettingBloc>().state.currency;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              context
                  .read<FinancialDashboardCubit>()
                  .setSummaryFilterBy(SummaryFilterBy.day);
            },
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  height: 60.h,
                  padding: getEdgeInsetsAll(12),
                  decoration: BoxDecoration(
                    color: filterBy == SummaryFilterBy.day
                        ? context.color.primary.withOpacity(_animation.value)
                        : context.color.onInverseSurface,
                    borderRadius: getRadius(16),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: context.color.primaryContainer,
                          borderRadius: getRadius(30),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            AppText(
                              text: currency.symbol,
                              style: StyleType.bodMd,
                              color: filterBy == SummaryFilterBy.day
                                  ? context.color.primaryContainer
                                  : null,
                            ),
                            AppText(
                              text: NumberFormatter.formatToMoneyDouble(
                                context,
                                widget.state.dayTotalAmount,
                                isSymbol: false,
                              ),
                              style: StyleType.headSm,
                              color: filterBy == SummaryFilterBy.day
                                  ? context.color.primaryContainer
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      AppText(
                        text: localize.day,
                        style: StyleType.bodLg,
                        color: filterBy == SummaryFilterBy.day
                            ? context.color.primaryContainer
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Gap.horizontal(5),
        Expanded(
          child: GestureDetector(
            onTap: () {
              context
                  .read<FinancialDashboardCubit>()
                  .setSummaryFilterBy(SummaryFilterBy.week);
            },
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  padding: getEdgeInsetsAll(12),
                  decoration: BoxDecoration(
                    color: filterBy == SummaryFilterBy.week
                        ? context.color.primary.withOpacity(_animation.value)
                        : context.color.onInverseSurface,
                    borderRadius: getRadius(30),
                  ),
                  child: Column(
                    children: [
                      AppText(
                        text: localize.week,
                        style: StyleType.bodLg,
                        color: filterBy == SummaryFilterBy.week
                            ? context.color.primaryContainer
                            : null,
                      ),
                      Gap.vertical(5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        mainAxisAlignment: MainAxisAlignment.center,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          AppText(
                            text: currency.symbol,
                            style: StyleType.bodMd,
                            color: filterBy == SummaryFilterBy.week
                                ? context.color.primaryContainer
                                : null,
                          ),
                          AppText(
                            text: NumberFormatter.formatToMoneyDouble(
                              context,
                              widget.state.weekTotalAmount,
                              isSymbol: false,
                            ),
                            style: StyleType.headSm,
                            color: filterBy == SummaryFilterBy.week
                                ? context.color.primaryContainer
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Gap.horizontal(5),
        Expanded(
          child: GestureDetector(
            onTap: () {
              context
                  .read<FinancialDashboardCubit>()
                  .setSummaryFilterBy(SummaryFilterBy.month);
            },
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  padding: getEdgeInsetsAll(12),
                  decoration: BoxDecoration(
                    color: filterBy == SummaryFilterBy.month
                        ? context.color.primary.withOpacity(_animation.value)
                        : context.color.onInverseSurface,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      AppText(
                        text: localize.month,
                        style: StyleType.bodLg,
                        color: filterBy == SummaryFilterBy.month
                            ? context.color.primaryContainer
                            : null,
                      ),
                      Gap.vertical(5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        mainAxisAlignment: MainAxisAlignment.center,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          AppText(
                            text: currency.symbol,
                            style: StyleType.bodMd,
                            color: filterBy == SummaryFilterBy.month
                                ? context.color.primaryContainer
                                : null,
                          ),
                          AppText(
                            text: NumberFormatter.formatToMoneyDouble(
                              context,
                              widget.state.monthTotalAmount,
                              isSymbol: false,
                            ),
                            style: StyleType.headSm,
                            color: filterBy == SummaryFilterBy.month
                                ? context.color.primaryContainer
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
