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
import 'package:uuid/uuid.dart';

class TransactionCalculatorBottomSheet extends StatefulWidget {
  const TransactionCalculatorBottomSheet({
    super.key,
  });

  @override
  State<TransactionCalculatorBottomSheet> createState() =>
      _TransactionCalculatorBottomSheetState();
}

class _TransactionCalculatorBottomSheetState
    extends State<TransactionCalculatorBottomSheet> {
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
    final isIncome = context.watch<FinancialDashboardCubit>().state.isIncome;
    final zeroExpression = notifier.expression == '0';
    final currencySymbol = context.watch<SettingBloc>().state.currency.symbol;
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
                  Expanded(
                    child: CategoryDropdown(
                      isIncome: isIncome,
                    ),
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
                      AppText(
                        text: currencySymbol,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              const Spacer(),
              FinancialCalculatorButtons(
                notifier: notifier,
              ),
              Gap.vertical(5),
              Row(
                children: [
                  const ButtonMember(),
                  Gap.horizontal(5),
                  Expanded(
                    child: BlocConsumer<FinancialTransactionBloc,
                        FinancialTransactionState>(
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
                        }

                        if (state.errorMessage != null) {
                          AppToast.showToastError(
                            context,
                            state.errorMessage ?? localize.failed,
                          );
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(382.w, 65.h),
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
                            final account = context
                                .read<AccountBloc>()
                                .state
                                .selectedAccount;
                            final location = context
                                .read<LocationCubit>()
                                .state
                                .transactionLocation;
                            final imageBytes = ControllerHelper.getImagesBytes(
                              context,
                            );
                            final date = context
                                .read<TimeScrollWheelCubit>()
                                .state
                                .selectedDate;
                            final isIncome = context
                                .read<FinancialDashboardCubit>()
                                .state
                                .isIncome;

                            final selectedMember = context
                                .read<MemberDbBloc>()
                                .state
                                .selectedMember;

                            if (notifier.result.trim() == '0' ||
                                notifier.result == ' ') {
                              AppToast.showToastError(
                                context,
                                localize.amountRequired,
                              );
                              return;
                            }

                            if (category == null) {
                              AppToast.showToastError(
                                context,
                                localize.categoryRequired,
                              );
                              return;
                            }

                            if (account == null) {
                              AppToast.showToastError(
                                context,
                                localize.accountRequired,
                              );
                              return;
                            }

                            if (selectedMember != null) {
                              final transaction = FinancialTransaction(
                                id: const Uuid().v4(),
                                createdAt: DateTime.now().toString(),
                                updatedAt: DateTime.now().toString(),
                                comment: _commentController.text,
                                amount: double.parse(
                                  notifier.result.replaceAll(',', ''),
                                ),
                                date: date.toString(),
                                type: isIncome ? 'income' : 'expense',
                                categoryName: category.categoryName,
                                accountName: account.name,
                                accountId: account.id,
                                categoryId: category.id,
                                transactionLocation: location,
                                picture: imageBytes,
                                memberId: selectedMember.id,
                                memberName: selectedMember.name,
                              );

                              context.read<FinancialTransactionBloc>().add(
                                    InsertFinancialTransactionEvent(
                                      transaction,
                                    ),
                                  );
                            }
                          },
                          child: AppText(
                            text: localize.recordTransaction,
                            style: StyleType.bodLg,
                            color: context.color.onPrimary,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Gap.vertical(20),
            ],
          ),
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