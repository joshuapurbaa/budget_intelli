import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/calculator/calculator_barrel.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AppCalculatorBottomSheet extends StatefulWidget {
  const AppCalculatorBottomSheet({
    super.key,
  });

  @override
  State<AppCalculatorBottomSheet> createState() =>
      _AppCalculatorBottomSheetState();
}

class _AppCalculatorBottomSheetState extends State<AppCalculatorBottomSheet> {
  final _commentController = TextEditingController();
  final notifier = CalculatorNotifier();

  @override
  void initState() {
    super.initState();
    notifier.addListener(() {
      setState(() {});
    });
    _resetState();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final zeroExpression = notifier.expression == '0';
    final currencySymbol = context.watch<SettingBloc>().state.currency.symbol;
    return Container(
      constraints: BoxConstraints(
        maxHeight: context.screenHeight * 0.60,
      ),
      padding: getEdgeInsetsSymmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            margin: getEdgeInsets(top: 10),
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: context.color.onInverseSurface,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
          Gap.vertical(15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: currencySymbol,
                        style: StyleType.bodLg,
                      ),
                      Gap.horizontal(5),
                      Expanded(
                        child: AppText.autoSize(
                          maxLines: 2,
                          text: NumberFormatter.formatStringToMoneyNoSymbol(
                            context,
                            notifier.result,
                          ),
                          style: StyleType.disLg,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!zeroExpression)
                  AppText(
                    text: notifier.expression,
                    style: StyleType.bodMed,
                    color: context.color.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w400,
                  ),
              ],
            ),
          ),
          Gap.vertical(5),
          AppCalculatorButtons(
            notifier: notifier,
          ),
          Gap.vertical(5),
          SafeArea(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(382.w, 60.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: context.color.primary,
              ),
              onPressed: () {
                final amount = NumberFormatter.formatStringToMoneyNoSymbol(
                  context,
                  notifier.result,
                );

                context.pop(amount);
              },
              child: AppText(
                text: localize.recordTransaction,
                style: StyleType.bodLg,
                color: context.color.onPrimary,
              ),
            ),
          ),
          Gap.vertical(20),
        ],
      ),
    );
  }

  void _setInitialValues() {
    final amount = ControllerHelper.getAmount(context);

    if (amount != null) {
      final formatter = NumberFormat('#,###');
      notifier.setInitialValues(
        result: formatter.format(amount),
        expression: formatter.format(amount),
      );
    } else {
      notifier.setInitialValues(
        result: '0',
        expression: '0',
      );
    }
  }

  void _resetState() {
    _commentController.clear();
    _setInitialValues();
    context.read<FinancialCategoryBloc>().add(
          const ResetFinancialCategoryStateEvent(),
        );

    context.read<AccountBloc>().add(
          ResetSelectedAccountStateEvent(),
        );

    context.read<MemberDbBloc>().add(
          const ResetMemberDbEventStateEvent(),
        );

    context.read<LocationCubit>().resetLocation();
    context.read<TimeScrollWheelCubit>().resetState();
    context.read<UploadImageBloc>().add(ResetImage());
  }
}
