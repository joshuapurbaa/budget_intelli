import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/category_barrel.dart';
import 'package:budget_intelli/features/home/home_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackingView extends StatefulWidget {
  const TrackingView({
    required this.budgetId,
    super.key,
  });

  final String budgetId;

  @override
  State<TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<TrackingView> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _getAllItemCategoryTransactions();
  }

  void _getAllItemCategoryTransactions() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackingCubit>()
        ..getItemCategoriesByBudgetId(widget.budgetId)
        ..getAllItemCategoryTransactionsByBudgetId(widget.budgetId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return BlocBuilder<TrackingCubit, TrackingState>(
      builder: (context, state) {
        final dailyTransactions = state.dailyTransactions;
        final weeklyTransactions = state.weeklyTransactions;
        final monthlyTransactions = state.monthlyTransactions;
        final yearlyTransactions = state.yearlyTransactions;
        final itemCategories = state.itemCategories;

        final itemCategoriesDaily = <ItemCategoryHistory>[];
        final itemCategoriesWeekly = <ItemCategoryHistory>[];
        final itemCategoriesMonthly = <ItemCategoryHistory>[];
        final itemCategoriesYearly = <ItemCategoryHistory>[];

        for (final itemCategory in itemCategories) {
          for (final transaction in dailyTransactions) {
            if (transaction.itemHistoId == itemCategory.id) {
              if (!itemCategoriesDaily.contains(itemCategory)) {
                itemCategoriesDaily.add(itemCategory);
              }
            }
          }

          for (final transaction in weeklyTransactions) {
            if (transaction.itemHistoId == itemCategory.id) {
              if (!itemCategoriesWeekly.contains(itemCategory)) {
                itemCategoriesWeekly.add(itemCategory);
              }
            }
          }

          for (final transaction in monthlyTransactions) {
            if (transaction.itemHistoId == itemCategory.id) {
              if (!itemCategoriesMonthly.contains(itemCategory)) {
                itemCategoriesMonthly.add(itemCategory);
              }
            }
          }

          for (final transaction in yearlyTransactions) {
            if (transaction.itemHistoId == itemCategory.id) {
              if (!itemCategoriesYearly.contains(itemCategory)) {
                itemCategoriesYearly.add(itemCategory);
              }
            }
          }
        }

        context.read<SearchTransactionCubit>()
          ..searchTransaction(
            _searchController.text,
            dailyTransactions,
          )
          ..setItemCategoriesFrequency(
            itemCategoriesDaily,
            dailyTransactions,
            'Daily',
          );

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Gap.vertical(10),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                _getAllItemCategoryTransactions();
              },
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: getEdgeInsets(left: 16, right: 16),
                height: 65.h,
                child: Row(
                  children: [
                    BlocBuilder<SearchTransactionCubit, SearchTransactionState>(
                      builder: (context, state) {
                        return Expanded(
                          child: AppSearch(
                            hintText: localize.searchTransactions,
                            controller: _searchController,
                            focusNode: _focusNode,
                            onChanged: (value) {
                              context
                                  .read<SearchTransactionCubit>()
                                  .searchTransaction(
                                    value,
                                    state.transactionsFrequency,
                                  );
                            },
                          ),
                        );
                      },
                    ),
                    Gap.horizontal(5),
                    GestureDetector(
                      onTap: () {
                        AppDialog.showCustomDialog(
                          context,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: AppText(
                                  text: localize.daily,
                                  style: StyleType.bodMed,
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () {
                                  context.read<SearchTransactionCubit>()
                                    ..searchTransaction(
                                      _searchController.text,
                                      dailyTransactions,
                                    )
                                    ..setItemCategoriesFrequency(
                                      itemCategoriesDaily,
                                      dailyTransactions,
                                      localize.daily,
                                    );
                                  Navigator.of(context).pop();
                                },
                              ),
                              const AppDivider(),
                              ListTile(
                                title: AppText(
                                  text: localize.weekly,
                                  style: StyleType.bodMed,
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () {
                                  context.read<SearchTransactionCubit>()
                                    ..searchTransaction(
                                      _searchController.text,
                                      weeklyTransactions,
                                    )
                                    ..setItemCategoriesFrequency(
                                      itemCategoriesWeekly,
                                      weeklyTransactions,
                                      localize.weekly,
                                    );
                                  Navigator.of(context).pop();
                                },
                              ),
                              const AppDivider(),
                              ListTile(
                                title: AppText(
                                  text: localize.monthly,
                                  style: StyleType.bodMed,
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () {
                                  context.read<SearchTransactionCubit>()
                                    ..searchTransaction(
                                      _searchController.text,
                                      monthlyTransactions,
                                    )
                                    ..setItemCategoriesFrequency(
                                      itemCategoriesMonthly,
                                      monthlyTransactions,
                                      localize.monthly,
                                    );
                                  Navigator.of(context).pop();
                                },
                              ),
                              const AppDivider(),
                              ListTile(
                                title: AppText(
                                  text: localize.yearly,
                                  style: StyleType.bodMed,
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () {
                                  context.read<SearchTransactionCubit>()
                                    ..searchTransaction(
                                      _searchController.text,
                                      yearlyTransactions,
                                    )
                                    ..setItemCategoriesFrequency(
                                      itemCategoriesYearly,
                                      yearlyTransactions,
                                      localize.yearly,
                                    );
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: const AppGlass(
                        child: Icon(
                          Icons.filter_list,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Gap.vertical(10),
            ),
            const SliverFillRemaining(
              child: FrequencyView(),
            ),
          ],
        );
      },
    );
  }
}
