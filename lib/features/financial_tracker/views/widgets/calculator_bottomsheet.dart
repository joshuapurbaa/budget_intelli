import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CalculatorBottomSheet extends StatelessWidget {
  const CalculatorBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      padding: getEdgeInsetsSymmetric(horizontal: 10),
      child: Stack(
        children: [
          Column(
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
              Gap.vertical(20),
              Row(
                children: [
                  const Expanded(
                    child: AccountDropdown(),
                  ),
                  Gap.horizontal(10),
                  const Expanded(
                    child: CategoryDropdown(),
                  ),
                ],
              ),
              Gap.vertical(15),
              AppText(
                text: 'Expenses',
                style: StyleType.bodLg,
                color: context.color.onSurface,
              ),
              Gap.vertical(15),
              BlocBuilder<FinancialCalculatorCubit, FinancialCalculatorState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AppText(
                            text: r'$',
                            style: StyleType.disSm,
                          ),
                          Gap.horizontal(5),
                          AppText(
                            text: NumberFormatter.formatStringToMoneyNoSymbol(
                              context,
                              state.amountDisplay,
                              decimalDigits: 0,
                            ),
                            style: StyleType.disLg,
                          ),
                        ],
                      ),
                      AppText(
                        text: state.expression,
                        style: StyleType.bodMd,
                        color: context.color.onSurface.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  );
                },
              ),
              const TextField(
                textAlign: TextAlign.center,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Add comment...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              const Spacer(),
              const CalculatorButtons(),
              Gap.vertical(8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(382.w, 58.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: context.color.primary,
                ),
                onPressed: () {
                  context.pop();
                },
                child: AppText(
                  text: 'Catat Transaksi',
                  style: StyleType.bodLg,
                  color: context.color.onPrimary,
                ),
              ),
              Gap.vertical(20),
            ],
          ),
        ],
      ),
    );
  }
}
