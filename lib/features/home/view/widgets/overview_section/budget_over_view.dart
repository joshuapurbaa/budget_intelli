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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

/// A comprehensive budget overview widget that displays budget summary,
/// category breakdowns, and provides budget management functionality
class BudgetOverview extends StatefulWidget {
  const BudgetOverview({
    required this.groupCategoryHistories,
    required this.budget,
    required this.totalActualExpense,
    required this.totalBudgetExpense,
    required this.totalActualIncome,
    required this.totalBudgetIncome,
    required this.user,
    required this.itemCategoryTransactions,
    required this.showAmount,
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
  final bool showAmount;
  @override
  State<BudgetOverview> createState() => _BudgetOverviewState();
}

class _BudgetOverviewState extends State<BudgetOverview> {
  /// Controls the expansion state of each category group
  List<bool> expandListTileValue = [];

  /// Controls whether the budget overview data table is visible
  bool openDataTable = false;

  @override
  void didUpdateWidget(covariant BudgetOverview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateBudgetTotalsIfChanged(oldWidget);
    _initializeExpandListStates();
  }

  @override
  void initState() {
    super.initState();
    _initializeCategoryColors();
    _initializeExpandListStates();
  }

  /// Updates budget totals when income or expense categories change
  void _updateBudgetTotalsIfChanged(BudgetOverview oldWidget) {
    var totalPlannedExpense = 0.0;
    var oldTotalPlannedIncome = 0.0;

    // Calculate old total planned income
    final oldGroupCategoryHistories = oldWidget.groupCategoryHistories;
    for (final groupCategoryHistory in oldGroupCategoryHistories) {
      if (groupCategoryHistory.type == 'income') {
        for (final itemCategoryHistory
            in groupCategoryHistory.itemCategoryHistories) {
          oldTotalPlannedIncome += itemCategoryHistory.amount;
        }
      }
    }

    // Update budget if total planned income changed
    if (oldTotalPlannedIncome != widget.totalBudgetIncome) {
      context.read<CategoryCubit>().updateBudget(
            budget: widget.budget.copyWith(
              totalPlanIncome: widget.totalBudgetIncome,
            ),
          );
    }

    // Update budget if number of categories changed
    if (oldWidget.groupCategoryHistories.length !=
        widget.groupCategoryHistories.length) {
      // Calculate new total planned expense
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
  }

  /// Initializes the color picker values for category groups
  void _initializeCategoryColors() {
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
  }

  /// Initializes the expansion states for all category groups
  void _initializeExpandListStates() {
    setState(() {
      expandListTileValue = List.generate(
        widget.groupCategoryHistories.length,
        (index) => false,
      );
    });
  }

  /// Handles successful group category deletion by refreshing data and showing success message
  void _handleGroupDeletionSuccess() {
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

  /// Handles successful group category update by refreshing data and showing success message
  void _handleGroupUpdateSuccess() {
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

  /// Handles successful budget update by refreshing data and showing success message
  void _handleBudgetUpdateSuccess() {
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

  /// Handles successful budget deletion by clearing state and navigating back
  void _handleBudgetDeletionSuccess() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<TrackingCubit>().setToInitial();
      context.read<SettingBloc>().add(ClearLastSeenBudgetIdEvent());
      context.read<CategoryCubit>().resetState();
      context.read<BudgetBloc>().add(BudgetBlocInitial());
      await context.read<BudgetsCubit>().getBudgets();
    });
  }

  /// Calculates budget financial metrics for display
  Map<String, double> _calculateBudgetMetrics() {
    final actualRemaining =
        widget.totalActualIncome - widget.totalActualExpense;
    final itemCategoryHistoryExpense = widget.groupCategoryHistories
        .where((element) => element.type == 'expense')
        .expand((element) => element.itemCategoryHistories)
        .toList();
    final totalPlannedExpense = itemCategoryHistoryExpense.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
    final plannedRemaining = widget.totalBudgetIncome - totalPlannedExpense;

    return {
      'actualRemaining': actualRemaining,
      'totalPlannedExpense': totalPlannedExpense,
      'plannedRemaining': plannedRemaining,
    };
  }

  @override
  Widget build(BuildContext context) {
    final groupsEmpty = widget.groupCategoryHistories.isEmpty;
    final dateRangeStr = _formatDateRange(context);
    final marginLRB = getEdgeInsets(left: 16, right: 16, bottom: 10);
    final expensesEmpty = _getExpenseCategories().isEmpty;
    final premiumUser = widget.user?.premium ?? false;

    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: _handleCategoryStateChanges,
      builder: (context, categoryState) {
        if (categoryState.successDeleteBudget) {
          return const ButtonAddBudget();
        }

        final budgetMetrics = _calculateBudgetMetrics();

        return _buildBudgetOverviewContent(
          context,
          groupsEmpty,
          dateRangeStr,
          marginLRB,
          expensesEmpty,
          premiumUser,
          budgetMetrics,
        );
      },
    );
  }

  /// Handles state changes from CategoryCubit
  void _handleCategoryStateChanges(BuildContext context, CategoryState state) {
    final localize = textLocalizer(context);

    if (state.successDelete != null && state.successDelete!) {
      _handleGroupDeletionSuccess();
    }

    if (state.successDeleteBudget) {
      _handleBudgetDeletionSuccess();
      AppToast.showToastSuccess(context, localize.successfullyDeleted);
    }

    if (state.successUpdate) {
      _handleGroupUpdateSuccess();
    }

    if (state.successUpdateBudget) {
      _handleBudgetUpdateSuccess();
    }
  }

  /// Formats the budget date range for display
  String _formatDateRange(BuildContext context) {
    final startDate = widget.budget.startDate;
    final endDate = widget.budget.endDate;
    final dateRanges = [startDate, endDate];
    return formatDateRangeStr(dateRanges, context);
  }

  /// Gets expense categories from group category histories
  List<GroupCategoryHistory> _getExpenseCategories() {
    return widget.groupCategoryHistories
        .where((element) => element.type == 'expense')
        .toList();
  }

  /// Builds the main budget overview content
  Widget _buildBudgetOverviewContent(
    BuildContext context,
    bool groupsEmpty,
    String dateRangeStr,
    EdgeInsetsGeometry marginLRB,
    bool expensesEmpty,
    bool premiumUser,
    Map<String, double> budgetMetrics,
  ) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        context.read<BudgetBloc>().add(
              GetBudgetsByIdEvent(id: widget.budget.id),
            );
      },
      child: RepaintBoundary(
        child: ListView(
          children: [
            Gap.vertical(10),
            const HeaderWidget(),
            const AnalyzeBudgetButton(),
            _buildBudgetSummaryCard(
              dateRangeStr,
              marginLRB,
              groupsEmpty,
              expensesEmpty,
              budgetMetrics,
            ),
            _buildCategoryGroupsList(
              budgetMetrics['plannedRemaining']!,
              widget.showAmount,
            ),
            _buildActionButtons(budgetMetrics['plannedRemaining']!),
            _buildDeleteBudgetSection(),
            if (!premiumUser) _buildAdSection(),
          ],
        ),
      ),
    );
  }

  /// Builds the budget summary card with pie chart and data table
  Widget _buildBudgetSummaryCard(
    String dateRangeStr,
    EdgeInsetsGeometry marginLRB,
    bool groupsEmpty,
    bool expensesEmpty,
    Map<String, double> budgetMetrics,
  ) {
    return AppGlass(
      duration: const Duration(milliseconds: 300),
      margin: marginLRB,
      padding: getEdgeInsets(left: 10, right: 10, top: 10),
      child: Column(
        children: [
          AppText(
            text: dateRangeStr,
            style: StyleType.bodLg,
          ),
          Gap.vertical(10),
          AppDivider(
            color: context.color.onSurface.withValues(alpha: 0.3),
          ),
          Gap.vertical(10),
          if (groupsEmpty)
            const CircularProgressIndicator.adaptive()
          else ...[
            Gap.vertical(10),
            PieChartOverview(
              groupCategoryHistories: widget.groupCategoryHistories,
              totalExpense: widget.budget.totalPlanExpense,
              expensesEmpty: expensesEmpty,
            ),
            _buildDataTableToggle(budgetMetrics),
          ],
        ],
      ),
    );
  }

  /// Builds the data table toggle section
  Widget _buildDataTableToggle(Map<String, double> budgetMetrics) {
    return Column(
      children: [
        if (!openDataTable)
          GestureDetector(
            onTap: () => setState(() => openDataTable = true),
            child: Icon(
              CupertinoIcons.chevron_compact_down,
              color: context.color.primary,
              size: 40,
            ),
          ),
        if (openDataTable) ...[
          Gap.vertical(10),
          BudgetOverviewTable(
            totalPlanIncome: widget.budget.totalPlanIncome,
            totalActualIncome: widget.totalActualIncome,
            totalPlanExpense: budgetMetrics['totalPlannedExpense']!,
            totalActualExpense: widget.totalActualExpense,
            plannedRemaining: budgetMetrics['plannedRemaining']!,
            actualRemaining: budgetMetrics['actualRemaining']!,
            showAmount: widget.showAmount,
          ),
          GestureDetector(
            onTap: () => setState(() => openDataTable = false),
            child: Icon(
              CupertinoIcons.chevron_compact_up,
              color: context.color.primary,
              size: 40,
            )
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .fadeOut(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 800),
                ),
          ),
        ],
      ],
    );
  }

  /// Builds the list of category groups with their items
  Widget _buildCategoryGroupsList(double plannedRemaining, bool showAmount) {
    return Column(
      children: List.generate(
        widget.groupCategoryHistories.length,
        (indexGroup) => _buildCategoryGroupCard(
          indexGroup,
          plannedRemaining,
          showAmount,
        ),
      ),
    );
  }

  /// Builds a single category group card
  Widget _buildCategoryGroupCard(
    int indexGroup,
    double plannedRemaining,
    bool showAmount,
  ) {
    final groupCategoryHistory = widget.groupCategoryHistories[indexGroup];
    final groupName = groupCategoryHistory.groupName;
    final items = groupCategoryHistory.itemCategoryHistories;
    final totalAmount = items.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
    final isIncome = groupCategoryHistory.type == 'income';

    return AppGlass(
      margin: getEdgeInsets(left: 16, right: 16, bottom: 10),
      child: Column(
        children: [
          _buildGroupHeader(
            indexGroup,
            groupName,
            totalAmount,
            groupCategoryHistory,
            showAmount,
          ),
          if (expandListTileValue[indexGroup]) ...[
            Gap.vertical(10),
            if (items.isNotEmpty)
              _buildCategoryItemsList(
                  items, plannedRemaining, groupCategoryHistory),
            Gap.vertical(10),
            _buildGroupActions(
                items, isIncome, groupCategoryHistory, plannedRemaining),
          ],
        ],
      ),
    );
  }

  /// Builds the header for a category group
  Widget _buildGroupHeader(
    int indexGroup,
    String groupName,
    double totalAmount,
    GroupCategoryHistory groupCategoryHistory,
    bool showAmount,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expandListTileValue[indexGroup] = !expandListTileValue[indexGroup];
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
          if (showAmount)
            AppText(
              text: NumberFormatter.formatToMoneyDouble(context, totalAmount),
              style: StyleType.bodMed,
              fontWeight: FontWeight.w700,
            )
          else
            Icon(
              FontAwesomeIcons.ellipsis,
              color: context.color.primary,
              size: 35,
            ),
          Gap.horizontal(10),
          _buildEditGroupButton(groupCategoryHistory, indexGroup, groupName),
        ],
      ),
    );
  }

  /// Builds the edit group button
  Widget _buildEditGroupButton(
    GroupCategoryHistory groupCategoryHistory,
    int indexGroup,
    String groupName,
  ) {
    return GestureDetector(
      onTap: () =>
          _showGroupEditDialog(groupCategoryHistory, indexGroup, groupName),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Color(groupCategoryHistory.hexColor),
        child: Icon(
          Icons.edit,
          color: context.color.onSurface,
          size: 14,
        ),
      ),
    );
  }

  /// Shows the group edit dialog
  void _showGroupEditDialog(
    GroupCategoryHistory groupCategoryHistory,
    int indexGroup,
    String groupName,
  ) {
    final localize = textLocalizer(context);
    context.read<CategoryCubit>().getItemCategoryArgs(
          groupCategoryHistory: groupCategoryHistory,
        );

    AppDialog.showCustomDialog(
      context,
      content: UpdateGroupCategoryContent(
        indexGroup: indexGroup,
        groupCategoryHistory: groupCategoryHistory,
        groupCategoryHistories: widget.groupCategoryHistories,
      ),
      actions: [
        AppButton(
          label: localize.save,
          onPressed: () => _handleGroupSave(groupName),
        ),
      ],
    );
  }

  /// Handles saving group changes
  void _handleGroupSave(String originalGroupName) {
    final localize = textLocalizer(context);
    final categoryState = context.read<CategoryCubit>().state;

    if (categoryState.groupCategoryHistory != null) {
      final updatedGroupName =
          categoryState.groupCategoryHistory!.groupName.toLowerCase();

      // Check for duplicate group names
      if (updatedGroupName != originalGroupName.toLowerCase()) {
        final existingGroup = categoryState.groupCategories
            .where((element) =>
                element.groupName.toLowerCase() == updatedGroupName)
            .firstOrNull;

        if (existingGroup != null) {
          AppToast.showToastError(context, localize.groupNameAlreadyExists);
          return;
        }
      }

      context.read<CategoryCubit>().updateGroupCategoryHistoryNoItemCategory(
            groupCategoryHistory: categoryState.groupCategoryHistory!,
          );
      context.pop();
    } else {
      AppToast.showToastError(context, localize.anErrorOccured);
    }
  }

  /// Builds the list of category items within a group
  Widget _buildCategoryItemsList(
    List<ItemCategoryHistory> items,
    double plannedRemaining,
    GroupCategoryHistory groupCategoryHistory,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, _) => AppDivider(
          padding: getEdgeInsetsAll(5),
          color: context.color.onSurface.withValues(alpha: 0.3),
        ),
        itemBuilder: (context, index) => _buildCategoryItem(
          items[index],
          plannedRemaining,
          groupCategoryHistory,
        ),
      ),
    );
  }

  /// Builds a single category item with progress tracking
  Widget _buildCategoryItem(
    ItemCategoryHistory item,
    double plannedRemaining,
    GroupCategoryHistory groupCategoryHistory,
  ) {
    final iconPath = item.iconPath;
    final iconPathNotNull = iconPath != null;
    final isIncome = item.type == 'income';
    final localize = textLocalizer(context);
    final showAmount = widget.showAmount;
    // Calculate progress metrics
    final actualAmount = widget.itemCategoryTransactions
        .where((element) => element.itemHistoId == item.id)
        .fold<double>(
            0, (previousValue, element) => previousValue + element.amount);

    final progressData =
        _calculateItemProgress(actualAmount, item.amount, isIncome);

    final percent = progressData['percent']!;
    final completed = percent == 1.0;

    return GestureDetector(
      onTap: () =>
          _navigateToItemDetail(item, plannedRemaining, groupCategoryHistory),
      child: Column(
        children: [
          Row(
            children: [
              _buildItemIcon(iconPath, iconPathNotNull),
              Gap.horizontal(8),
              Expanded(
                child: RowText(
                  left: item.name,
                  styleTypeLeft: StyleType.bodSm,
                  styleTypeRight: StyleType.bodSm,
                  fontWeightLeft: FontWeight.w500,
                  right:
                      NumberFormatter.formatToMoneyDouble(context, item.amount),
                  lineThrough: completed,
                  showAmount: showAmount,
                ),
              ),
              if (completed) ...[
                Gap.horizontal(5),
                AppText(
                  text: localize.completed,
                  style: StyleType.bodSm,
                  color: context.color.primary,
                ),
              ]
            ],
          ),
          if (percent > 0) ...[
            Gap.vertical(5),
            _buildProgressIndicator(progressData, actualAmount),
          ],
        ],
      ),
    );
  }

  /// Builds the icon for a category item
  Widget _buildItemIcon(String? iconPath, bool iconPathNotNull) {
    return SizedBox(
      width: 30.w,
      child: iconPathNotNull
          ? Image.asset(iconPath!, width: 30)
          : Icon(
              CupertinoIcons.photo,
              color: context.color.primary,
              size: 18,
            ),
    );
  }

  /// Calculates progress data for a category item
  Map<String, double> _calculateItemProgress(
      double actualAmount, double budgetAmount, bool isIncome) {
    var percent = 0.0;
    var percentValue = 0.0;
    // Color? percentTextColor;

    if (actualAmount != 0) {
      percentValue = (actualAmount / budgetAmount) * 100;
      percent = percentValue / 100;
      // percentTextColor = context.color.onSurface.withValues(alpha: 0.5);

      if (percent > 1) {
        percent = 1;
        // percentTextColor = isIncome
        //     ? AppColor.green.withValues(alpha: 0.5)
        //     : context.color.error.withValues(alpha: 0.5);
      }
    }

    return {
      'percent': percent,
      'percentValue': percentValue,
    };
  }

  /// Builds the progress indicator for a category item
  Widget _buildProgressIndicator(
    Map<String, double> progressData,
    double actualAmount,
  ) {
    final localize = textLocalizer(context);
    final percent = progressData['percent']!;
    final percentValue = progressData['percentValue']!;

    final isOverTarget = percentValue > 100;
    final overspending = localize.overspending;

    var percentStr = '${percentValue.truncate()}%';
    if (isOverTarget) {
      percentStr = '$percentStr ${(percentValue > 100) ? overspending : ''}';
    }

    final percentTextColor = isOverTarget
        ? context.color.error.withValues(alpha: 0.5)
        : context.color.onSurface.withValues(alpha: 0.5);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: LinearPercentIndicator(
                animation: true,
                lineHeight: 8,
                animationDuration: 700,
                percent: percent,
                barRadius: const Radius.circular(8),
                progressColor: context.color.primary,
                backgroundColor: Colors.transparent,
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
                    text: localize.actual,
                    style: StyleType.bodSm,
                    color: percentTextColor,
                    fontStyle: FontStyle.italic,
                  ),
                  Gap.horizontal(4),
                  AppText(
                    text: ':',
                    style: StyleType.bodSm,
                    color: percentTextColor,
                    fontStyle: FontStyle.italic,
                  ),
                  Gap.horizontal(4),
                  AppText(
                    text: NumberFormatter.formatToMoneyDouble(
                      context,
                      actualAmount,
                    ),
                    style: StyleType.bodSm,
                    color: percentTextColor,
                    fontStyle: FontStyle.italic,
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
    );
  }

  /// Navigates to the item detail screen
  void _navigateToItemDetail(
    ItemCategoryHistory item,
    double plannedRemaining,
    GroupCategoryHistory groupCategoryHistory,
  ) {
    context.read<CategoryCubit>()
      ..getItemCategoryArgs(
        itemCategoryHistory: item,
        groupCategoryHistories: widget.groupCategoryHistories,
        budget: widget.budget,
        addNewItemCategory: false,
        lefToBudget: plannedRemaining,
        groupCategoryHistory: groupCategoryHistory,
      )
      ..getItemCategoryTransactions(itemId: item.id);

    context.pushNamed(MyRoute.detailCategory.noSlashes());
  }

  /// Builds action buttons for a category group
  Widget _buildGroupActions(
    List<ItemCategoryHistory> items,
    bool isIncome,
    GroupCategoryHistory groupCategoryHistory,
    double plannedRemaining,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAddCategoryButton(groupCategoryHistory, plannedRemaining),
        if (items.isNotEmpty && !isIncome)
          _buildDeleteGroupButton(groupCategoryHistory),
      ],
    );
  }

  /// Builds the add category button
  Widget _buildAddCategoryButton(
    GroupCategoryHistory groupCategoryHistory,
    double plannedRemaining,
  ) {
    final localize = textLocalizer(context);
    return GestureDetector(
      onTap: () {
        context.read<CategoryCubit>().getItemCategoryArgs(
              addNewItemCategory: true,
              groupCategoryHistories: widget.groupCategoryHistories,
              groupCategoryHistory: groupCategoryHistory,
              budget: widget.budget,
            );
        context.pushNamed(MyRoute.detailCategory.noSlashes());
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: context.color.primary,
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
    );
  }

  /// Builds the delete group button
  Widget _buildDeleteGroupButton(
    GroupCategoryHistory groupCategoryHistory,
  ) {
    final localize = textLocalizer(context);
    return GestureDetector(
      onTap: () async {
        final title = localize.deleteGroupCategory;
        final textContent = localize.confirmDeleteGroupCategory;
        final result = await AppDialog.showConfirmationDelete(
          context,
          title,
          textContent,
        );
        if (result != null) {
          _deleteGroupCategory(groupCategoryHistory.id,
              widget.groupCategoryHistories.indexOf(groupCategoryHistory));
        }
      },
      child: const Icon(CupertinoIcons.delete),
    );
  }

  /// Builds action buttons for creating new groups and budgets
  Widget _buildActionButtons(double plannedRemaining) {
    return Column(
      children: [
        _buildNewGroupButton(plannedRemaining),
        _buildNewBudgetButton(),
      ],
    );
  }

  /// Builds the new group button
  Widget _buildNewGroupButton(double plannedRemaining) {
    final localize = textLocalizer(context);
    return GestureDetector(
      onTap: () {
        context.read<CategoryCubit>().getBudgetAndGroup(
              budget: widget.budget,
              groupCategoryHistory: widget.groupCategoryHistories,
              lefToBudget: plannedRemaining,
            );
        context.pushNamed(MyRoute.addGroupCategory.noSlashes());
      },
      child: AppGlass(
        margin: getEdgeInsets(left: 16, right: 16, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            Icon(CupertinoIcons.add, color: context.color.primary),
            Gap.horizontal(10),
            Expanded(
              flex: 2,
              child: AppText(text: localize.newGroup, style: StyleType.bodMed),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the new budget button
  Widget _buildNewBudgetButton() {
    final localize = textLocalizer(context);
    return GestureDetector(
      onTap: () {
        context.read<BudgetFormBloc>().add(BudgetFormDefaultValues());
        context.pushNamed(MyRoute.createNewBudgetScreen.noSlashes());
      },
      child: AppGlass(
        margin: getEdgeInsets(left: 16, right: 16, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
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
    );
  }

  /// Builds the delete budget section
  Widget _buildDeleteBudgetSection() {
    final localize = textLocalizer(context);

    return Padding(
      padding: getEdgeInsets(left: 16, right: 16, bottom: 10),
      child: Column(
        children: [
          AppButton.outlined(
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
                _deleteBudget(widget.budget.id);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Builds the advertisement section for non-premium users
  Widget _buildAdSection() {
    return AdWidgetRepository(
      height: 50,
      child: Container(color: context.color.surface),
    );
  }

  /// Deletes a budget by its ID
  void _deleteBudget(String budgetId) {
    context.read<CategoryCubit>().deleteBudgetById(id: budgetId);
  }

  /// Deletes a group category and updates the UI accordingly
  void _deleteGroupCategory(String id, int indexGroup) {
    context.read<CategoryCubit>()
      ..deleteGroupCategory(id: id)
      ..getGroupIdDeletedIndex(indexGroup);
  }
}
