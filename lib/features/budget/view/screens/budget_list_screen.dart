import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetListScreen extends StatefulWidget {
  const BudgetListScreen({super.key});

  @override
  State<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends State<BudgetListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(GetGroupBudgetCategoryHistory());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, state) {
        var groupCategoryList = <GroupCategoryHistory>[];
        final success = state is GetGroupBudgetLoaded;
        final error = state is BudgetError;
        final loading = state is BudgetLoading;

        if (success) {
          groupCategoryList = state.groupCategoryList;
        }
        return AppScaffold(
          appBarTitle: 'Budget',
          children: [
            if (loading) const Center(child: CircularProgressIndicator()),
            if (error) const Center(child: Text('Error')),
            if (success)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  itemCount: groupCategoryList.length,
                  itemBuilder: (context, index) {
                    final groupCategory = groupCategoryList[index];
                    final itemCategory = groupCategory.itemCategoryHistories;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: groupCategory.groupName,
                          style: StyleType.disSm,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: getEdgeInsets(bottom: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: itemCategory.length,
                          itemBuilder: (context, index) {
                            final item = itemCategory[index];
                            return Row(
                              children: [
                                AppText(
                                  text: item.name,
                                  style: StyleType.headSm,
                                ),
                                Gap.horizontal(16),
                                AppText(
                                  text: NumberFormatter.formatToMoneyInt(
                                    context,
                                    item.amount,
                                  ),
                                  style: StyleType.headSm,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
