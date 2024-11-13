import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/core/widgets/charts/app_chart.bar.dart';
import 'package:budget_intelli/core/widgets/charts/pair_chart_monthly.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/view/controllers/insight/insight_cubit.dart';
import 'package:budget_intelli/features/home/data/models/category_total.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InsightView extends StatefulWidget {
  const InsightView({
    required this.budgetId,
    super.key,
  });

  final String budgetId;

  @override
  State<InsightView> createState() => _InsightViewState();
}

class _InsightViewState extends State<InsightView> {
  ItemCategoryHistory? selectedItemCategory;
  ItemCategoryHistory? selectedItemCategoryBreakdown;
  String selectedFrequency = 'Daily';
  final frequencies = [
    'Daily',
    'Monthly',
    'Yearly',
  ];
  List<bool> expandListTileValue = [false, false];

  @override
  void initState() {
    super.initState();
    _getAllItemCategoryTransactions();
  }

  void _getAllItemCategoryTransactions() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InsightCubit>().getItemCategoriesByBudgetId(widget.budgetId);
      context
          .read<InsightCubit>()
          .getAllItemCategoryTransactionsByBudgetId(widget.budgetId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final paddingLRB = getEdgeInsets(left: 16, right: 16, bottom: 10);
    return BlocBuilder<InsightCubit, InsightState>(
      builder: (context, state) {
        final itemCategories = state.itemCategories;
        final allTransactions = state.allTransactions;
        final oneMonthTransactions = state.oneMonthTransactions;
        final threeMonthTransactions = state.threeMonthTransactions;
        final sixMonthTransactions = state.sixMonthTransactions;
        final nineMonthTransactions = state.nineMonthTransactions;
        final twelveMonthTransactions = state.twelveMonthTransactions;

        final itemCategoriesOneMonth = <ItemCategoryHistory>[];
        final itemCategoriesThreeMonth = <ItemCategoryHistory>[];
        final itemCategoriesSixMonth = <ItemCategoryHistory>[];
        final itemCategoriesNineMonth = <ItemCategoryHistory>[];
        final itemCategoriesTwelveMonth = <ItemCategoryHistory>[];
        final onlyIncomeCategries = <ItemCategoryHistory>[];
        final onlySpendingCategories = <ItemCategoryHistory>[];
        final onlyIncomeTransactions = <ItemCategoryTransaction>[];
        final onlySpendingTransactions = <ItemCategoryTransaction>[];

        for (final itemCategory in itemCategories) {
          if (itemCategory.type == AppStrings.incomeType) {
            onlyIncomeCategries.add(itemCategory);
          } else {
            onlySpendingCategories.add(itemCategory);
          }
        }

        for (final transaction in allTransactions) {
          if (transaction.type == AppStrings.incomeType) {
            onlyIncomeTransactions.add(transaction);
          } else {
            onlySpendingTransactions.add(transaction);
          }
        }

        final incomeCategoryTotals = <CategoryTotal>[];
        final spendingCategoryTotals = <CategoryTotal>[];

        for (final itemCategory in onlyIncomeCategries) {
          var total = 0.0;
          for (final transaction in onlyIncomeTransactions) {
            if (itemCategory.id == transaction.itemHistoId) {
              total += transaction.amount;
            }
          }
          incomeCategoryTotals.add(
            CategoryTotal(
              name: itemCategory.name,
              total: total,
              iconPath: itemCategory.iconPath,
            ),
          );
        }

        for (final itemCategory in onlySpendingCategories) {
          var total = 0.0;
          for (final transaction in onlySpendingTransactions) {
            if (itemCategory.id == transaction.itemHistoId) {
              total += transaction.amount;
            }
          }
          spendingCategoryTotals.add(
            CategoryTotal(
              name: itemCategory.name,
              total: total,
              iconPath: itemCategory.iconPath,
            ),
          );
        }

        // sort by total from highest to lowest
        incomeCategoryTotals.sort((a, b) => b.total.compareTo(a.total));
        spendingCategoryTotals.sort((a, b) => b.total.compareTo(a.total));

        for (final itemCategory in itemCategories) {
          for (final transaction in oneMonthTransactions) {
            if (itemCategory.id == transaction.itemHistoId) {
              if (!itemCategoriesOneMonth.contains(itemCategory)) {
                itemCategoriesOneMonth.add(itemCategory);
              }
            }
          }

          for (final transaction in threeMonthTransactions) {
            if (itemCategory.id == transaction.itemHistoId) {
              if (!itemCategoriesThreeMonth.contains(itemCategory)) {
                itemCategoriesThreeMonth.add(itemCategory);
              }
            }
          }

          for (final transaction in sixMonthTransactions) {
            if (itemCategory.id == transaction.itemHistoId) {
              if (!itemCategoriesSixMonth.contains(itemCategory)) {
                itemCategoriesSixMonth.add(itemCategory);
              }
            }
          }

          for (final transaction in nineMonthTransactions) {
            if (itemCategory.id == transaction.itemHistoId) {
              if (!itemCategoriesNineMonth.contains(itemCategory)) {
                itemCategoriesNineMonth.add(itemCategory);
              }
            }
          }

          for (final transaction in twelveMonthTransactions) {
            if (itemCategory.id == transaction.itemHistoId) {
              if (!itemCategoriesTwelveMonth.contains(itemCategory)) {
                itemCategoriesTwelveMonth.add(itemCategory);
              }
            }
          }
        }

        return RefreshIndicator.adaptive(
          onRefresh: () async {
            _getAllItemCategoryTransactions();
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AppGlass(
                  margin: getEdgeInsets(
                    left: 16,
                    right: 16,
                    bottom: 10,
                    top: 10,
                  ),
                  child: ExpansionTile(
                    expansionAnimationStyle: AnimationStyle(
                      duration: const Duration(
                        milliseconds: 100,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    childrenPadding: getEdgeInsets(
                      left: 16,
                      right: 16,
                    ),
                    title: AppText(
                      text: localize.incomeCategoryTotals,
                      style: StyleType.bodMd,
                      fontWeight: FontWeight.bold,
                    ),
                    trailing: Icon(
                      expandListTileValue[0]
                          ? CupertinoIcons.chevron_up
                          : CupertinoIcons.chevron_down,
                    ),
                    onExpansionChanged: (value) {
                      setState(() {
                        expandListTileValue[0] = value;
                      });
                    },
                    children: List.generate(
                      incomeCategoryTotals.length,
                      (index) {
                        final category = incomeCategoryTotals[index];
                        final name = category.name;
                        final total = category.total;
                        final iconPath = category.iconPath;
                        final iconPathNotNull = iconPath != null;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              if (iconPathNotNull) ...[
                                SizedBox(
                                  width: 20.w,
                                  child: Image.asset(
                                    iconPath,
                                    width: 30,
                                  ),
                                ),
                                Gap.horizontal(8),
                              ] else ...[
                                SizedBox(
                                  width: 20.w,
                                  child: Icon(
                                    CupertinoIcons.photo,
                                    color: context.color.primary,
                                    size: 18,
                                  ),
                                ),
                                Gap.horizontal(8),
                              ],
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        text: name,
                                        style: StyleType.bodMd,
                                      ),
                                    ),
                                    AppText(
                                      text: NumberFormatter.formatToMoneyDouble(
                                        context,
                                        total,
                                      ),
                                      style: StyleType.bodMd,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AppGlass(
                  margin: paddingLRB,
                  child: ExpansionTile(
                    expansionAnimationStyle: AnimationStyle(
                      duration: const Duration(
                        milliseconds: 100,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    childrenPadding: getEdgeInsets(
                      left: 16,
                      right: 16,
                    ),
                    title: AppText(
                      text: localize.spendingCategoryTotals,
                      style: StyleType.bodMd,
                      fontWeight: FontWeight.bold,
                    ),
                    trailing: Icon(
                      expandListTileValue[1]
                          ? CupertinoIcons.chevron_up
                          : CupertinoIcons.chevron_down,
                    ),
                    onExpansionChanged: (value) {
                      setState(() {
                        expandListTileValue[1] = value;
                      });
                    },
                    children: List.generate(
                      spendingCategoryTotals.length,
                      (index) {
                        final category = spendingCategoryTotals[index];
                        final name = category.name;
                        final total = category.total;
                        final iconPath = category.iconPath;
                        final iconPathNotNull = iconPath != null;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              if (iconPathNotNull) ...[
                                SizedBox(
                                  width: 20.w,
                                  child: Image.asset(
                                    iconPath,
                                    width: 30,
                                  ),
                                ),
                                Gap.horizontal(8),
                              ] else ...[
                                SizedBox(
                                  width: 20.w,
                                  child: Icon(
                                    CupertinoIcons.photo,
                                    color: context.color.primary,
                                    size: 18,
                                  ),
                                ),
                                Gap.horizontal(8),
                              ],
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        text: name,
                                        style: StyleType.bodMd,
                                      ),
                                    ),
                                    AppText(
                                      text: NumberFormatter.formatToMoneyDouble(
                                        context,
                                        total,
                                      ),
                                      style: StyleType.bodMd,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // _InsightPart(
              //   title: 'Category Totals',
              //   children: [
              //     DropdownButtonHideUnderline(
              //       child: DropdownButton2<ItemCategory>(
              //         isExpanded: true,
              //         hint: Row(
              //           children: [
              //             Expanded(
              //               child: AppText(
              //                 text: localize.selectCategory,
              //                 style: StyleType.smallDef12,
              //               ),
              //             ),
              //           ],
              //         ),
              //         items: itemCategories
              //             .map(
              //               (ItemCategory item) => DropdownMenuItem<ItemCategory>(
              //                 value: item,
              //                 child: AppText(
              //                   text: item.name,
              //                   style: StyleType.smallDef12,
              //                 ),
              //               ),
              //             )
              //             .toList(),
              //         value: selectedItemCategory,
              //         onChanged: (value) {
              //           setState(() {
              //             selectedItemCategory = value;
              //           });
              //           context.read<InsightCubit>().filterTransactionsByCategory(
              //                 value!.id,
              //               );
              //         },
              //         buttonStyleData: ButtonStyleData(
              //           height: 50,
              //           width: 160,
              //           padding: const EdgeInsets.only(left: 14, right: 14),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(14),
              //             border: Border.all(
              //               color: Colors.black26,
              //             ),
              //             color: context.color.surfaceVariant,
              //           ),
              //           elevation: 2,
              //         ),
              //         iconStyleData: IconStyleData(
              //           icon: const Icon(
              //             Icons.arrow_forward_ios_outlined,
              //           ),
              //           iconSize: 14,
              //           iconEnabledColor: context.color.onSurfaceVariant,
              //           iconDisabledColor: Colors.grey,
              //         ),
              //         dropdownStyleData: DropdownStyleData(
              //           maxHeight: 200,
              //           width: 200,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(14),
              //             color: context.color.surfaceVariant,
              //           ),
              //           offset: const Offset(-20, 0),
              //           scrollbarTheme: ScrollbarThemeData(
              //             radius: const Radius.circular(40),
              //             thickness: MaterialStateProperty.all(6),
              //             thumbVisibility: MaterialStateProperty.all(true),
              //           ),
              //         ),
              //         menuItemStyleData: const MenuItemStyleData(
              //           height: 40,
              //           padding: EdgeInsets.only(left: 14, right: 14),
              //         ),
              //       ),
              //     ),
              //     Gap.vertical(16),
              //     const LineChartMonthlyTotals(),
              //   ],
              // ),
              _InsightPart(
                title: localize.categoryBreakdown,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<ItemCategoryHistory>(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Expanded(
                                  child: AppText(
                                    text: localize.selectCategory,
                                    style: StyleType.bodSm,
                                  ),
                                ),
                              ],
                            ),
                            items: itemCategories
                                .map(
                                  (ItemCategoryHistory item) =>
                                      DropdownMenuItem<ItemCategoryHistory>(
                                    value: item,
                                    child: AppText(
                                      text: item.name,
                                      style: StyleType.bodSm,
                                    ),
                                  ),
                                )
                                .toList(),
                            value: selectedItemCategoryBreakdown,
                            onChanged: (value) {
                              setState(() {
                                selectedItemCategoryBreakdown = value;
                              });
                              context
                                  .read<InsightCubit>()
                                  .filterSpendingBreakdown(
                                    categoryId: value!.id,
                                  );
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 40,
                              width: 160,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                color: context.color.surfaceContainerHighest,
                              ),
                              elevation: 2,
                            ),
                            iconStyleData: IconStyleData(
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: context.color.onSurfaceVariant,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: context.color.surfaceContainerHighest,
                              ),
                              offset: const Offset(-20, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: WidgetStateProperty.all(6),
                                thumbVisibility: WidgetStateProperty.all(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ),
                      Gap.horizontal(16),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Expanded(
                                  child: AppText(
                                    text: localize.selectFrequency,
                                    style: StyleType.bodSm,
                                  ),
                                ),
                              ],
                            ),
                            items: frequencies
                                .map(
                                  (String frequency) =>
                                      DropdownMenuItem<String>(
                                    value: frequency,
                                    child: AppText(
                                      text: frequency,
                                      style: StyleType.bodSm,
                                    ),
                                  ),
                                )
                                .toList(),
                            value: selectedFrequency,
                            onChanged: (value) {
                              setState(() {
                                selectedFrequency = value!;
                              });
                              context.read<InsightCubit>().setSelectedFrequency(
                                    value!,
                                  );
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 40,
                              width: 160,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                color: context.color.surfaceContainerHighest,
                              ),
                              elevation: 2,
                            ),
                            iconStyleData: IconStyleData(
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: context.color.onSurfaceVariant,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: context.color.surfaceContainerHighest,
                              ),
                              offset: const Offset(-20, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: WidgetStateProperty.all(6),
                                thumbVisibility: WidgetStateProperty.all(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap.vertical(40),
                  const Expanded(
                    child: AppChartBar(),
                  ),
                ],
              ),
              _InsightPart(
                title: localize.incomeVsSpending,
                children: [
                  Gap.vertical(30),
                  const Expanded(
                    child: PairChartMonthly(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InsightPart extends StatelessWidget {
  const _InsightPart({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final paddingLRB = getEdgeInsets(
      left: 16,
      right: 16,
      bottom: 10,
    );
    return SliverToBoxAdapter(
      child: AppGlass(
        margin: paddingLRB,
        height: 300,
        child: Column(
          children: [
            AppText(
              text: title,
              style: StyleType.bodMd,
              fontWeight: FontWeight.bold,
            ),
            Gap.vertical(16),
            ...children,
          ],
        ),
      ),
    );
  }
}
