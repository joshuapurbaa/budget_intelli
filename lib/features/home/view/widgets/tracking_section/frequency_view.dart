import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/category_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FrequencyView extends StatefulWidget {
  const FrequencyView({
    super.key,
  });

  @override
  State<FrequencyView> createState() => _FrequencyViewState();
}

class _FrequencyViewState extends State<FrequencyView> {
  bool isIncome = false;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final paddingLRB = getEdgeInsets(left: 16, right: 16, bottom: 16);
    return BlocBuilder<SearchTransactionCubit, SearchTransactionState>(
      builder: (context, state) {
        final transactions = state.searchTransactions;

        final transactionsFrequency =
            transactions.isEmpty ? state.transactionsFrequency : transactions;

        final transactionsFrequencyOnlyIncome = transactionsFrequency
            .where((element) => element.type == AppStrings.incomeType)
            .toList();

        final transactionsFrequencyOnlyExpense = transactionsFrequency
            .where((element) => element.type == AppStrings.expenseType)
            .toList();

        final itemCategoryHistories = state.itemCategoryHistoriesFrequency;

        final totalAmountTransactionsExpenses =
            transactionsFrequencyOnlyExpense.fold(
          0,
          (previousValue, element) => previousValue + element.amount,
        );
        final totalAmountTransactionsIncome =
            transactionsFrequencyOnlyIncome.fold(
          0,
          (previousValue, element) => previousValue + element.amount,
        );
        final title = state.titleFrequency;
        var transactionsListviewData = <ItemCategoryTransaction>[];

        if (isIncome) {
          transactionsListviewData = transactionsFrequencyOnlyIncome;
        } else {
          transactionsListviewData = transactionsFrequencyOnlyExpense;
        }

        return RefreshIndicator.adaptive(
          onRefresh: () async {
            context.read<SearchTransactionCubit>().searchTransaction(
                  '',
                  transactions,
                );
          },
          child: ListView(
            padding: getEdgeInsets(bottom: 40),
            children: [
              SizedBox(
                height: 130.h,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: getEdgeInsets(left: 16),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isIncome = false;
                            });
                          },
                          child: AppGlass(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getPngAsset(
                                  isIncome ? eyeClose : eyeOpen,
                                  color: context.color.onSurface,
                                ),
                                Gap.vertical(4),
                                AppText(
                                  text: '$title ${localize.expenses}',
                                  style: StyleType.bodMd,
                                  maxLines: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                Gap.vertical(8),
                                AppText(
                                  text: NumberFormatter.formatToMoneyInt(
                                    context,
                                    totalAmountTransactionsExpenses,
                                  ),
                                  style: StyleType.bodMd,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap.horizontal(10),
                    Expanded(
                      child: Padding(
                        padding: getEdgeInsets(right: 16),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isIncome = true;
                            });
                          },
                          child: AppGlass(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getPngAsset(
                                  isIncome ? eyeOpen : eyeClose,
                                  color: context.color.onSurface,
                                ),
                                Gap.vertical(4),
                                AppText(
                                  text: '$title ${localize.income}',
                                  style: StyleType.bodMd,
                                  maxLines: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                AppText(
                                  text: NumberFormatter.formatToMoneyInt(
                                    context,
                                    totalAmountTransactionsIncome,
                                  ),
                                  style: StyleType.bodMd,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // PieChartPortion(
              //   itemCategories: itemCategoriesExcludeIncome,
              //   transactions: transactionsFrequencyExcludeIncome,
              // ),
              Gap.vertical(16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactionsListviewData.length,
                padding: paddingLRB,
                itemBuilder: (context, index) {
                  ItemCategoryHistory? itemCategory;

                  for (final categoryHistory in itemCategoryHistories) {
                    if (isIncome) {
                      if (categoryHistory.id ==
                              transactionsListviewData[index].itemHistoId &&
                          categoryHistory.type == AppStrings.incomeType) {
                        itemCategory = categoryHistory;
                      }
                    } else {
                      if (categoryHistory.id ==
                              transactionsListviewData[index].itemHistoId &&
                          categoryHistory.type == AppStrings.expenseType) {
                        itemCategory = categoryHistory;
                      }
                    }
                  }
                  final hexColor = itemCategory?.hexColor;
                  final transaction = transactionsListviewData[index];
                  final transactionDate = transaction.createdAt;
                  final formatDate = getDayMonth(transactionDate, context);
                  final spendOn = transaction.spendOn;
                  final amount = transaction.amount;
                  final createdAtDateTime = DateTime.parse(transactionDate);
                  final hour = createdAtDateTime.hour;
                  final minute = createdAtDateTime.minute;
                  final time = '$hour:$minute';
                  final iconPath = itemCategory?.iconPath;
                  final categoryName = itemCategory?.name;

                  return TransactionItemList(
                    formatDate: formatDate,
                    spendOn: spendOn,
                    amount: amount,
                    time: time,
                    noChevron: true,
                    hexColor: hexColor,
                    categoryName: categoryName,
                    iconPath: iconPath,
                  );
                },
                separatorBuilder: (context, index) => AppDivider(
                  padding: getEdgeInsets(top: 10, bottom: 10),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
