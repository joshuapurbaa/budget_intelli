import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/category_barrel.dart';
import 'package:budget_intelli/features/home/home_barrel.dart';
import 'package:budget_intelli/features/home/view/widgets/overview_section/header_widget.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

class OverView extends StatefulWidget {
  const OverView({
    required this.groupCategoryHistories,
    required this.budget,
    required this.totalActualExpense,
    required this.totalBudgetExpense,
    required this.totalActualIncome,
    required this.totalBudgetIncome,
    required this.user,
    required this.itemCategoryTransactions,
    super.key,
  });

  final List<GroupCategoryHistory> groupCategoryHistories;
  final Budget budget;
  final double totalActualExpense;
  final double totalBudgetExpense;
  final double totalActualIncome;
  final double totalBudgetIncome;
  final UserIntelli? user;
  final List<ItemCategoryTransaction> itemCategoryTransactions;

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  List<bool> expandListTileValue = [];
  bool openDataTable = false;

  @override
  void didUpdateWidget(covariant OverView oldWidget) {
    super.didUpdateWidget(oldWidget);

    var totalPlannedExpense = 0.0;
    var oldTotalPlannedIncome = 0.0;

    final oldGroupCategoryHistories = oldWidget.groupCategoryHistories;
    for (final groupCategoryHistory in oldGroupCategoryHistories) {
      if (groupCategoryHistory.type == 'income') {
        for (final itemCategoryHistory
            in groupCategoryHistory.itemCategoryHistories) {
          oldTotalPlannedIncome += itemCategoryHistory.amount;
        }
      }
    }

    if (oldTotalPlannedIncome != widget.totalBudgetIncome) {
      context.read<CategoryCubit>().updateBudget(
            budget: widget.budget.copyWith(
              totalPlanIncome: widget.totalBudgetIncome,
            ),
          );
    }

    if (oldWidget.groupCategoryHistories.length !=
        widget.groupCategoryHistories.length) {
      for (var i = 0; i < widget.groupCategoryHistories.length; i++) {
        if (widget.groupCategoryHistories[i].type == 'expense') {
          for (var j = 0;
              j < widget.groupCategoryHistories[i].itemCategoryHistories.length;
              j++) {
            totalPlannedExpense += widget
                .groupCategoryHistories[i].itemCategoryHistories[j].amount;
          }
        }
      }

      context.read<CategoryCubit>().updateBudget(
            budget: widget.budget.copyWith(
              totalPlanExpense: totalPlannedExpense,
            ),
          );
    }

    setState(() {
      expandListTileValue = List.generate(
        widget.groupCategoryHistories.length,
        (index) => false,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    context.read<CategoryCubit>().getItemCategoryArgs(
          pickerColor: List.generate(
            widget.groupCategoryHistories.length,
            (index) => Color(widget.groupCategoryHistories[index].hexColor),
          ),
          currentColor: List.generate(
            widget.groupCategoryHistories.length,
            (index) => Color(widget.groupCategoryHistories[index].hexColor),
          ),
        );

    setState(() {
      expandListTileValue = List.generate(
        widget.groupCategoryHistories.length,
        (index) => false,
      );
    });
  }

  void _onSuccessDeleteGroup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localize = textLocalizer(context);

      context.read<BudgetBloc>().add(
            GetBudgetsByIdEvent(
              id: widget.budget.id,
            ),
          );

      AppToast.showToastSuccess(
        context,
        localize.successfullyDeleted,
      );

      context.read<CategoryCubit>().resetState();
    });
  }

  void _onSuccessUpdateGroup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BudgetBloc>().add(
            GetBudgetsByIdEvent(
              id: widget.budget.id,
            ),
          );

      AppToast.showToastSuccess(
        context,
        textLocalizer(context).updatedSuccessFully,
      );

      context.read<CategoryCubit>().resetState();
    });
  }

  void _onUpdateBudgetSucess() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BudgetBloc>().add(
            GetBudgetsByIdEvent(
              id: widget.budget.id,
            ),
          );

      AppToast.showToastSuccess(
        context,
        textLocalizer(context).updatedSuccessFully,
      );

      context.read<CategoryCubit>().resetState();
    });
  }

  void _onSuccessDeleteBudget() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<TrackingCubit>().setToInitial();
      context.read<SettingBloc>().add(ClearLastSeenBudgetIdEvent());
      context.read<CategoryCubit>().resetState();
      context.read<BudgetBloc>().add(BudgetBlocInitial());
      await context.read<BudgetsCubit>().getBudgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupsEmpty = widget.groupCategoryHistories.isEmpty;
    final localize = textLocalizer(context);
    final startDate = widget.budget.startDate;
    final endDate = widget.budget.endDate;
    final dateRanges = [startDate, endDate];
    final dateRangeStr = formatDateRangeStr(dateRanges, context);
    final marginLRB = getEdgeInsets(left: 16, right: 16, bottom: 10);
    final groupCategoryHistories = widget.groupCategoryHistories;
    final expenseCategories = groupCategoryHistories
        .where((element) => element.type == 'expense')
        .toList();
    final expensesEmpty = expenseCategories.isEmpty;
    final budget = widget.budget;
    final userIntelli = widget.user;
    final premiumUser = userIntelli?.premium ?? false;

    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state.successDelete != null) {
          if (state.successDelete!) {
            _onSuccessDeleteGroup();
          }
        }

        if (state.successDeleteBudget) {
          _onSuccessDeleteBudget();
          AppToast.showToastSuccess(
            context,
            localize.successfullyDeleted,
          );
        }

        if (state.successUpdate) {
          _onSuccessUpdateGroup();
        }

        if (state.successUpdateBudget) {
          _onUpdateBudgetSucess();
        }
      },
      builder: (context, categoryState) {
        if (categoryState.successDeleteBudget) {
          return const ButtonAddBudget();
        }

        final actualRemaining =
            widget.totalActualIncome - widget.totalActualExpense;
        final itemCategoryHistoryExpense = groupCategoryHistories
            .where(
              (element) => element.type == 'expense',
            )
            .expand(
              (element) => element.itemCategoryHistories,
            )
            .toList();
        final totalPlannedExpense = itemCategoryHistoryExpense.fold<double>(
          0,
          (previousValue, element) => previousValue + element.amount,
        );

        final plannedRemaining = widget.totalBudgetIncome - totalPlannedExpense;

        return RefreshIndicator.adaptive(
          onRefresh: () async {
            context.read<BudgetBloc>().add(
                  GetBudgetsByIdEvent(
                    id: budget.id,
                  ),
                );
          },
          child: RepaintBoundary(
            child: ListView(
              children: [
                Gap.vertical(10),
                const HeaderWidget(),
                const AnalyzeBudgetButton(),
                AppGlass(
                  duration: const Duration(milliseconds: 300),
                  margin: marginLRB,
                  padding: getEdgeInsets(
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  child: Column(
                    children: [
                      AppText.autoSize(
                        text: dateRangeStr,
                        style: StyleType.bodLg,
                      ),
                      Gap.vertical(10),
                      const AppDivider(),
                      Gap.vertical(10),
                      if (groupsEmpty)
                        const CircularProgressIndicator.adaptive()
                      else ...[
                        PieChartOverview(
                          groupCategoryHistories: groupCategoryHistories,
                          totalExpense: budget.totalPlanExpense,
                          expensesEmpty: expensesEmpty,
                        ),
                        if (!openDataTable) ...[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                openDataTable = true;
                              });
                            },
                            child: Icon(
                              CupertinoIcons.chevron_compact_down,
                              color: context.color.primary,
                              size: 40,
                            ),
                          ),
                        ],
                        if (openDataTable) ...[
                          Gap.vertical(10),
                          BudgetOverviewTable(
                            totalPlanIncome: budget.totalPlanIncome,
                            totalActualIncome: widget.totalActualIncome,
                            totalPlanExpense: totalPlannedExpense,
                            totalActualExpense: widget.totalActualExpense,
                            plannedRemaining: plannedRemaining,
                            actualRemaining: actualRemaining,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                openDataTable = false;
                              });
                            },
                            child: Icon(
                              CupertinoIcons.chevron_compact_up,
                              color: context.color.primary,
                              size: 40,
                            )
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .fadeOut(
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 800),
                                ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                Column(
                  children: List.generate(
                    groupCategoryHistories.length,
                    (indexGroup) {
                      final groupCategoryHistory =
                          widget.groupCategoryHistories[indexGroup];

                      final groupName = groupCategoryHistory.groupName;
                      final items = groupCategoryHistory.itemCategoryHistories;

                      final totalAmount = items.fold<double>(
                        0,
                        (previousValue, element) =>
                            previousValue + element.amount,
                      );

                      final isIncome = groupCategoryHistory.type == 'income';

                      return AppGlass(
                        margin: getEdgeInsets(
                          left: 16,
                          right: 16,
                          bottom: 10,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  expandListTileValue[indexGroup] =
                                      !expandListTileValue[indexGroup];
                                });
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          expandListTileValue[indexGroup]
                                              ? CupertinoIcons.chevron_down
                                              : CupertinoIcons.chevron_right,
                                          color: context.color.primary,
                                        ),
                                        Gap.horizontal(10),
                                        Expanded(
                                          child: AppText(
                                            text: groupName,
                                            style: StyleType.bodMed,
                                            maxLines: 2,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Gap.horizontal(10),
                                  AppText(
                                    text: NumberFormatter.formatToMoneyDouble(
                                      context,
                                      totalAmount,
                                    ),
                                    style: StyleType.bodMed,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  Gap.horizontal(10),
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<CategoryCubit>()
                                          .getItemCategoryArgs(
                                            groupCategoryHistory:
                                                groupCategoryHistory,
                                          );

                                      AppDialog.showCustomDialog(
                                        context,
                                        content: UpdateGroupCategoryContent(
                                          indexGroup: indexGroup,
                                          groupCategoryHistory:
                                              groupCategoryHistory,
                                          groupCategoryHistories:
                                              groupCategoryHistories,
                                        ),
                                        actions: [
                                          AppButton(
                                            label: localize.save,
                                            onPressed: () {
                                              final categoryState = context
                                                  .read<CategoryCubit>()
                                                  .state;

                                              if (categoryState
                                                      .groupCategoryHistory !=
                                                  null) {
                                                final updatedGroupName =
                                                    categoryState
                                                        .groupCategoryHistory!
                                                        .groupName
                                                        .toLowerCase();

                                                if (updatedGroupName !=
                                                    groupName.toLowerCase()) {
                                                  final group = categoryState
                                                      .groupCategories
                                                      .where(
                                                        (element) =>
                                                            element.groupName
                                                                .toLowerCase() ==
                                                            updatedGroupName,
                                                      )
                                                      .firstOrNull;

                                                  if (group != null) {
                                                    AppToast.showToastError(
                                                      context,
                                                      localize
                                                          .groupNameAlreadyExists,
                                                    );
                                                    return;
                                                  }
                                                }

                                                context
                                                    .read<CategoryCubit>()
                                                    .updateGroupCategoryHistoryNoItemCategory(
                                                      groupCategoryHistory:
                                                          categoryState
                                                              .groupCategoryHistory!,
                                                    );
                                                context.pop();
                                              } else {
                                                AppToast.showToastError(
                                                  context,
                                                  localize.anErrorOccured,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Color(
                                        groupCategoryHistory.hexColor,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: context.color.onSurface,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (expandListTileValue[indexGroup]) ...[
                              Gap.vertical(10),
                              if (items.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: context.color.onPrimary,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: items.length,
                                    separatorBuilder: (context, _) =>
                                        const AppDivider(
                                      padding: EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                      ),
                                    ),
                                    itemBuilder: (context, index) {
                                      final iconPath = items[index].iconPath;
                                      final iconPathNotNull = iconPath != null;
                                      final isIncome =
                                          items[index].type == 'income';

                                      var percent = 0.0;
                                      var percentStr = '0%';
                                      Color? percentTextColor;
                                      var barColor = context.color.primary;
                                      final actualAmount = widget
                                          .itemCategoryTransactions
                                          .where(
                                            (element) =>
                                                element.itemHistoId ==
                                                items[index].id,
                                          )
                                          .fold<double>(
                                            0,
                                            (previousValue, element) =>
                                                previousValue + element.amount,
                                          );

                                      if (actualAmount != 0) {
                                        final percents = actualAmount /
                                            (items[index].amount) *
                                            100;

                                        percent = percents / 100;
                                        percentStr = '${percents.truncate()}%';
                                        percentTextColor = context
                                            .color.onSurface
                                            .withValues(alpha: 0.5);

                                        if (percent > 1) {
                                          percent = 1;
                                          percentStr = isIncome
                                              ? '$percentStr Overperformance'
                                              : '$percentStr Overspending';
                                          percentTextColor = isIncome
                                              ? AppColor.green
                                                  .withValues(alpha: 0.5)
                                              : context.color.error
                                                  .withValues(alpha: 0.5);
                                        }
                                      }

                                      if (items[index].hexColor != null) {
                                        barColor =
                                            Color(items[index].hexColor!);
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          context.read<CategoryCubit>()
                                            ..getItemCategoryArgs(
                                              itemCategoryHistory: items[index],
                                              groupCategoryHistories:
                                                  groupCategoryHistories,
                                              budget: budget,
                                              addNewItemCategory: false,
                                              lefToBudget: plannedRemaining,
                                              groupCategoryHistory:
                                                  groupCategoryHistory,
                                            )
                                            ..getItemCategoryTransactions(
                                              itemId: items[index].id,
                                            );

                                          context.pushNamed(
                                            MyRoute.detailCategory.noSlashes(),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                if (iconPathNotNull) ...[
                                                  SizedBox(
                                                    width: 30.w,
                                                    child: Image.asset(
                                                      iconPath,
                                                      width: 30,
                                                    ),
                                                  ),
                                                  Gap.horizontal(8),
                                                ] else ...[
                                                  SizedBox(
                                                    width: 30.w,
                                                    child: Icon(
                                                      CupertinoIcons.photo,
                                                      color:
                                                          context.color.primary,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  Gap.horizontal(8),
                                                ],
                                                Expanded(
                                                  child: RowText(
                                                    left: items[index].name,
                                                    styleTypeLeft:
                                                        StyleType.bodSm,
                                                    styleTypeRight:
                                                        StyleType.bodSm,
                                                    fontWeightLeft:
                                                        FontWeight.w500,
                                                    right: NumberFormatter
                                                        .formatToMoneyDouble(
                                                      context,
                                                      items[index].amount,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (percent > 0) ...[
                                              Gap.vertical(5),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            LinearPercentIndicator(
                                                          animation: true,
                                                          lineHeight: 8,
                                                          animationDuration:
                                                              700,
                                                          percent: percent,
                                                          barRadius:
                                                              const Radius
                                                                  .circular(
                                                            8,
                                                          ),
                                                          progressColor:
                                                              barColor,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Gap.vertical(5),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            AppText(
                                                              text: localize
                                                                  .actual,
                                                              style: StyleType
                                                                  .bodSm,
                                                              color:
                                                                  percentTextColor,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                            ),
                                                            Gap.horizontal(4),
                                                            AppText(
                                                              text: ':',
                                                              style: StyleType
                                                                  .bodSm,
                                                              color:
                                                                  percentTextColor,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                            ),
                                                            Gap.horizontal(4),
                                                            AppText(
                                                              text: NumberFormatter
                                                                  .formatToMoneyDouble(
                                                                context,
                                                                actualAmount,
                                                              ),
                                                              style: StyleType
                                                                  .bodSm,
                                                              color:
                                                                  percentTextColor,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      AppText(
                                                        text: percentStr,
                                                        style: StyleType.bodSm,
                                                        color: percentTextColor,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              Gap.vertical(10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<CategoryCubit>()
                                          .getItemCategoryArgs(
                                            addNewItemCategory: true,
                                            groupCategoryHistories:
                                                groupCategoryHistories,
                                            groupCategoryHistory:
                                                groupCategoryHistory,
                                            budget: budget,
                                          );
                                      context.pushNamed(
                                        MyRoute.detailCategory.noSlashes(),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor:
                                              context.color.primary,
                                          child: Icon(
                                            CupertinoIcons.add,
                                            size: 18,
                                            color: context.color.surface,
                                          ),
                                        ),
                                        Gap.horizontal(10),
                                        AppText(
                                          text: localize.addCategory,
                                          style: StyleType.bodMed,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (items.isNotEmpty && !isIncome)
                                    GestureDetector(
                                      onTap: () async {
                                        final title =
                                            localize.deleteGroupCategory;
                                        final textContent =
                                            localize.confirmDeleteGroupCategory;
                                        final result = await AppDialog
                                            .showConfirmationDelete(
                                          context,
                                          title,
                                          textContent,
                                        );
                                        if (result != null) {
                                          _onDeleteGroupCategory(
                                            groupCategoryHistory.id,
                                            indexGroup,
                                          );
                                        }
                                      },
                                      child: const Icon(
                                        CupertinoIcons.delete,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<CategoryCubit>().getBudgetAndGroup(
                          budget: widget.budget,
                          groupCategoryHistory: groupCategoryHistories,
                          lefToBudget: plannedRemaining,
                        );

                    context.pushNamed(
                      MyRoute.addGroupCategory.noSlashes(),
                    );
                  },
                  child: AppGlass(
                    margin: getEdgeInsets(
                      left: 16,
                      right: 16,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Icon(
                          CupertinoIcons.add,
                          color: context.color.primary,
                        ),
                        Gap.horizontal(10),
                        Expanded(
                          flex: 2,
                          child: AppText(
                            text: localize.newGroup,
                            style: StyleType.bodMed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<BudgetFormBloc>().add(
                          BudgetFormToInitial(),
                        );

                    context.pushNamed(
                      MyRoute.addNewBudgetScreen.noSlashes(),
                    );
                  },
                  child: AppGlass(
                    margin: getEdgeInsets(left: 16, right: 16, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Icon(
                          CupertinoIcons.add,
                          color: context.color.primary,
                        ),
                        Gap.horizontal(10),
                        Expanded(
                          flex: 2,
                          child: AppText(
                            text: localize.newBudget,
                            style: StyleType.bodMed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: getEdgeInsets(left: 16, right: 16, bottom: 10),
                  child: Column(
                    children: [
                      OutlineButtonPrimary(
                        label: localize.deleteBudget,
                        onPressed: () async {
                          final title = localize.deleteBudget;
                          final textContent = localize.confirmDeleteBudget;
                          final result = await AppDialog.showConfirmationDelete(
                            context,
                            title,
                            textContent,
                          );

                          if (result != null) {
                            _onDeleteBudgetById(widget.budget.id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (!premiumUser) ...[
                  // Gap.vertical(32),
                  // AppButton(
                  //   label: localize.buyPremium,
                  //   onPressed: () {
                  //     _showPremiumModalBottom(userIntelli);
                  //   },
                  // ),

                  AdWidgetRepository(
                    // user: userIntelli,
                    height: 50,
                    child: Container(
                      color: context.color.surface,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _onDeleteBudgetById(String budgetId) {
    context.read<CategoryCubit>().deleteBudgetById(
          id: budgetId,
        );
  }

  void _onDeleteGroupCategory(String id, int indexGroup) {
    context.read<CategoryCubit>()
      ..deleteGroupCategory(
        id: id,
      )
      ..getGroupIdDeletedIndex(
        indexGroup,
      );
  }
}
