import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/calculator/calculator_barrel.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CalculatorBottomSheet extends StatefulWidget {
  const CalculatorBottomSheet({
    super.key,
  });

  @override
  State<CalculatorBottomSheet> createState() => _CalculatorBottomSheetState();
}

class _CalculatorBottomSheetState extends State<CalculatorBottomSheet> {
  final _commentController = TextEditingController();
  final notifier = CalculatorNotifier();

  @override
  void initState() {
    super.initState();
    notifier.addListener(() {
      setState(() {});
    });
    _setInitialValues();
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

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final isIncome = context.watch<FinancialDashboardCubit>().state.isIncome;
    final zeroExpression = notifier.expression == '0';
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
                text: isIncome ? localize.income : localize.expenses,
                style: StyleType.bodLg,
                color: context.color.onSurface,
              ),
              Gap.vertical(15),
              Column(
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
                        text: notifier.result,
                        style: StyleType.disLg,
                      ),
                    ],
                  ),
                  if (!zeroExpression)
                    AppText(
                      text: notifier.expression,
                      style: StyleType.bodMd,
                      color: context.color.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                ],
              ),
              TextField(
                controller: _commentController,
                textAlign: TextAlign.center,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: '${localize.addComment}...',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              const Spacer(),
              CalculatorButtons(
                notifier: notifier,
              ),
              Gap.vertical(8),
              BlocListener<FinancialTransactionBloc, FinancialTransactionState>(
                listener: (context, state) {
                  if (state.insertSuccess) {
                    context.pop();
                    context.read<FinancialTransactionBloc>().add(
                          const ResetFinancialTransactionStateEvent(),
                        );
                    context
                        .read<FinancialDashboardCubit>()
                        .getAllFinancialTransactionByMonthAndYear(
                          context,
                          namaBulan: context
                              .read<FinancialDashboardCubit>()
                              .state
                              .selectedMonth,
                        );
                  } else {
                    AppToast.showToastError(context, localize.failed);
                  }
                },
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(382.w, 58.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: context.color.primary,
                  ),
                  onPressed: () {
                    final category = context
                        .read<FinancialCategoryBloc>()
                        .state
                        .selectedFinancialCategory;
                    final account =
                        context.read<AccountBloc>().state.selectedAccount;
                    final location =
                        context.read<LocationCubit>().state.transactionLocation;
                    final imageBytes = ControllerHelper.getImagesBytes(
                      context,
                    );
                    final date =
                        context.read<TimeScrollWheelCubit>().state.selectedDate;
                    final isIncome =
                        context.read<FinancialDashboardCubit>().state.isIncome;

                    if (category != null && account != null) {
                      final transaction = FinancialTransaction(
                        id: const Uuid().v4(),
                        createdAt: DateTime.now().toString(),
                        updatedAt: DateTime.now().toString(),
                        comment: _commentController.text,
                        amount:
                            double.parse(notifier.result.replaceAll(',', '')),
                        date: date.toString(),
                        type: isIncome ? 'income' : 'expense',
                        categoryName: category.categoryName,
                        accountName: account.name,
                        accountId: account.id,
                        categoryId: category.id,
                        transactionLocation: location,
                        picture: imageBytes,
                      );

                      context.read<FinancialTransactionBloc>().add(
                            InsertFinancialTransactionEvent(transaction),
                          );
                    }
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
        ],
      ),
    );
  }
}
