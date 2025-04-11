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
  String? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final paddingLRB = getEdgeInsets(left: 16, right: 16, bottom: 16);
    return BlocBuilder<SearchTransactionCubit, SearchTransactionState>(
      builder: (context, state) {
        final transactions = state.searchTransactions;

        final transactionsFrequency =
            transactions.isEmpty ? state.transactionsFrequency : transactions;

        // Filter berdasarkan kategori jika ada
        var filteredTransactions = transactionsFrequency;
        if (selectedCategoryId != null) {
          filteredTransactions = transactionsFrequency
              .where((element) => element.itemHistoId == selectedCategoryId)
              .toList();
        }

        final transactionsFrequencyOnlyIncome = filteredTransactions
            .where((element) => element.type == AppStrings.incomeType)
            .toList();

        final transactionsFrequencyOnlyExpense = filteredTransactions
            .where((element) => element.type == AppStrings.expenseType)
            .toList();

        final itemCategoryHistories = state.itemCategoryHistoriesFrequency;

        // Filter kategori berdasarkan tipe (income/expense)
        final filteredCategories = itemCategoryHistories
            .where((category) =>
                category.type ==
                (isIncome ? AppStrings.incomeType : AppStrings.expenseType))
            .toList();

        final totalAmountTransactionsExpenses =
            transactionsFrequencyOnlyExpense.fold(
          0.0,
          (previousValue, element) => previousValue + element.amount,
        );
        final totalAmountTransactionsIncome =
            transactionsFrequencyOnlyIncome.fold(
          0.0,
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
                              selectedCategoryId = null;
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
                                  text: NumberFormatter.formatToMoneyDouble(
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
                              selectedCategoryId = null;
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
                                  text: NumberFormatter.formatToMoneyDouble(
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

              Padding(
                padding: getEdgeInsets(left: 16, right: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      filteredCategories.length,
                      (index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategoryId = null;
                              });
                            },
                            child: AppGlass(
                              borderRadius: 8,
                              margin: getEdgeInsets(right: 8),
                              child: Center(
                                child: AppText(
                                  text: localize.all,
                                  style: StyleType.bodMd,
                                  fontWeight: selectedCategoryId == null
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: selectedCategoryId == null
                                      ? context.color.primary
                                      : context.color.onSurface,
                                ),
                              ),
                            ),
                          );
                        }

                        final category = filteredCategories[index - 1];
                        final isSelected = selectedCategoryId == category.id;

                        return AppGlass(
                          borderRadius: 8,
                          margin: getEdgeInsets(right: 8),
                          onTap: () {
                            setState(() {
                              selectedCategoryId = category.id;
                            });
                          },
                          child: Row(
                            children: [
                              if (category.iconPath != null)
                                getPngAsset(
                                  category.iconPath!,
                                  color: isSelected
                                      ? context.color.primary
                                      : context.color.primaryContainer,
                                ),
                              Gap.horizontal(8),
                              AppText(
                                text: category.name,
                                style: StyleType.bodMd,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? context.color.onPrimaryContainer
                                    : context.color.onSurface,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
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
