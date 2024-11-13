import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/category_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class AddGroupCategoryScreen extends StatefulWidget {
  const AddGroupCategoryScreen({super.key});

  @override
  State<AddGroupCategoryScreen> createState() => _AddGroupCategoryScreenState();
}

class _AddGroupCategoryScreenState extends State<AddGroupCategoryScreen> {
  String categoryType = 'expense';
  bool isExpense = true;
  int totalNewGroup = 1;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryState = context.read<CategoryCubit>().state;
      final budgetId = categoryState.budget?.id;
      context.read<CategoryCubit>()
        ..getGroupCategories()
        ..getItemCategories()
        ..getGroupCategoryHistoryByBudgetId(
          budgetId: budgetId!,
        );
      _getItemCategoryHistory();
      context.read<BudgetFormBloc>().add(
            BudgetFormInitialNew(
              budgetId: budgetId,
              categoryType: categoryType,
              isExpenses: isExpense,
            ),
          );
    });
  }

  Future<void> _insertToFirestore(CategoryState state) async {
    final groupCategoryHistory = state.groupCategoryHistoriesParam;
    final itemCategoriesParams = state.itemCategoryHistoriesParam;
    final itemCategories = state.itemCategories;
    final groupCategories = state.groupCategories;
    await context.read<BudgetFirestoreCubit>().insertNewGroupCategoryFirestore(
          groupCategoryHistory: groupCategoryHistory,
          itemCategoriesParams: itemCategoriesParams,
          itemCategories: itemCategories,
          groupCategories: groupCategories,
        );
  }

  void _afterSuccess(CategoryState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localize = textLocalizer(context);

      context.read<BudgetBloc>().add(
            GetBudgetsByIdEvent(
              id: state.budget!.id,
            ),
          );

      AppToast.showToastSuccess(
        context,
        localize.createdSuccessFully,
      );
      context.read<CategoryCubit>().resetState();
      context.read<BudgetFirestoreCubit>().resetState();
      if (context.canPop()) {
        context.pop(totalNewGroup);
      }
    });
  }

  void _onSuccessCreated(CategoryState state) {
    final settingState = context.read<SettingBloc>().state;
    final premium = settingState.user?.premium ?? false;

    if (premium) {
      _insertToFirestore(state);
      _afterSuccess(state);
    } else {
      _afterSuccess(state);
    }
  }

  void _getItemCategoryHistory() {
    final lastSeenBudgetId = context.read<SettingBloc>().state.lastSeenBudgetId;
    final budgetIdNotNullOrNotEmpty =
        lastSeenBudgetId != null && lastSeenBudgetId.isNotEmpty;
    if (budgetIdNotNullOrNotEmpty) {
      context.read<CategoryCubit>().getItemCategoryHistoriesByBudgetId(
            lastSeenBudgetId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final paddingLRT = getEdgeInsets(left: 16, right: 16, top: 10);
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, categoryState) {
        final budget = categoryState.budget;
        final budgetName = budget?.budgetName ?? '-';

        if (categoryState.successInsert) {
          _onSuccessCreated(categoryState);
        }
        return Scaffold(
          body: BlocBuilder<BudgetFormBloc, BudgetFormState>(
            builder: (context, formState) {
              final groupCategoryHistories = formState.groupCategoryHistories;
              final allItemCategoryHistories =
                  formState.allItemCategoryHistories;
              const groupNameInitialEN = 'Group Name';
              const groupNameInitialID = 'Nama Grup';
              const categoryNameInitialEN = 'Category Name';
              const categoryNameInitialID = 'Nama Kategori';
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBarPrimary(
                    title: localize.addGroupCategory,
                  ),
                  SliverPadding(
                    padding: paddingLRT,
                    sliver: SliverToBoxAdapter(
                      child: AppGlass(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${localize.leftToBudget2}: ',
                                style: textStyle(
                                  context,
                                  StyleType.bodMd,
                                ).copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: NumberFormatter.formatToMoneyDouble(
                                  context,
                                  categoryState.leftToBudget ?? 0.0,
                                ),
                                style: textStyle(
                                  context,
                                  StyleType.bodLg,
                                ).copyWith(
                                  color: context.color.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: paddingLRT,
                    sliver: SliverToBoxAdapter(
                      child: AppGlass(
                        height: 70.h,
                        child: Row(
                          children: [
                            getPngAsset(
                              budgetPng,
                              height: 20,
                              width: 20,
                            ),
                            Gap.horizontal(16),
                            AppText(
                              text: budgetName,
                              style: StyleType.bodMd,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: paddingLRT,
                    sliver: SliverList.separated(
                      itemCount: groupCategoryHistories.length,
                      itemBuilder: (context, index) {
                        final categories =
                            groupCategoryHistories[index].itemCategoryHistories;
                        final groupCategoryHistory =
                            groupCategoryHistories[index];
                        final categoryType = groupCategoryHistories[index].type;

                        final isIncome = categoryType == 'income';

                        return AppGlass(
                          child: FormNewBudgetGroup(
                            fromInitial: false,
                            isIncome: isIncome,
                            groupCategoryHistory: groupCategoryHistory,
                            itemCategoryHistories: categories,
                            budgetId: budget!.id,
                            categoryType: categoryType,
                            allItemCategoryHistories: allItemCategoryHistories,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Gap.vertical(10),
                    ),
                  ),
                  SliverPadding(
                    padding: paddingLRT,
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          if (!(formState.insertBudgetSuccess == true))
                            AppButton(
                              label: localize.save,
                              onPressed: () {
                                final budgetID = categoryState.budget?.id;
                                final groupCategoryHistories =
                                    formState.groupCategoryHistories;
                                final groupCategoryLen =
                                    groupCategoryHistories.length;
                                final groupCategoryHistoryParams =
                                    <GroupCategoryHistory>[];
                                final itemCategoriesParams =
                                    <ItemCategoryHistory>[];

                                for (var i = 0; i < groupCategoryLen; i++) {
                                  final itemCategories =
                                      groupCategoryHistories[i]
                                          .itemCategoryHistories
                                          .length;
                                  final groupName =
                                      groupCategoryHistories[i].groupName;

                                  if (groupName.isEmpty ||
                                      groupName == groupNameInitialEN ||
                                      groupName == groupNameInitialID ||
                                      groupName == localize.groupName) {
                                    AppToast.showToastError(
                                      context,
                                      localize.groupNameCannotBeEmpty,
                                      gravity: ToastGravity.CENTER,
                                    );
                                    return;
                                  }

                                  final params = GroupCategoryHistory(
                                    id: groupCategoryHistories[i].id,
                                    groupName:
                                        groupCategoryHistories[i].groupName,
                                    method: groupCategoryHistories[i].method,
                                    type: groupCategoryHistories[i].type,
                                    groupId: groupCategoryHistories[i].groupId,
                                    budgetId: budgetID,
                                    createdAt:
                                        groupCategoryHistories[i].createdAt,
                                    updatedAt:
                                        groupCategoryHistories[i].updatedAt,
                                    hexColor:
                                        groupCategoryHistories[i].hexColor,
                                  );

                                  groupCategoryHistoryParams.add(params);

                                  for (var j = 0; j < itemCategories; j++) {
                                    final item = groupCategoryHistories[i]
                                        .itemCategoryHistories[j];
                                    final itemName = item.name;

                                    if (itemName.isEmpty ||
                                        itemName == categoryNameInitialID ||
                                        itemName == categoryNameInitialEN ||
                                        item.amount == 0 ||
                                        itemName == localize.selectCategory ||
                                        itemName == localize.typeCategoryName) {
                                      AppToast.showToastError(
                                        context,
                                        localize
                                            .categoryNameAndAmountCannotBeEmpty,
                                        gravity: ToastGravity.CENTER,
                                      );
                                      return;
                                    }

                                    final itemCategory = ItemCategoryHistory(
                                      id: item.id,
                                      name: item.name,
                                      groupHistoryId: formState
                                          .groupCategoryHistories[i].id,
                                      itemId: item.itemId,
                                      amount: item.amount,
                                      type: item.type,
                                      createdAt: item.createdAt,
                                      isExpense: item.isExpense,
                                      budgetId: budget!.id,
                                      groupName:
                                          groupCategoryHistories[i].groupName,
                                    );

                                    itemCategoriesParams.add(itemCategory);
                                  }
                                }

                                context
                                    .read<CategoryCubit>()
                                    .insertNewGroupCategory(
                                      groupCategoryHistoryParams:
                                          groupCategoryHistoryParams,
                                      itemCategoryHistoryParams:
                                          itemCategoriesParams,
                                    );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
