import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/home/home_barrel.dart';
import 'package:budget_intelli/features/home/view/widgets/insight_section/insight_view.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({
    required this.user,
    super.key,
  });

  final UserIntelli? user;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<BudgetsCubit>().getBudgets();
    _getBudgetById(null);
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  void _getBudgetById(String? lastSeenBudgetId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PromptAnalysisCubit>().setLanguage();
      final budgetId = lastSeenBudgetId ??
          context.read<SettingBloc>().state.lastSeenBudgetId;

      final budgetIdNotNullOrNotEmpty = budgetId != null && budgetId.isNotEmpty;

      if (budgetIdNotNullOrNotEmpty) {
        context.read<BudgetsCubit>().getBudgets();
        context.read<BudgetBloc>().add(GetBudgetsByIdEvent(id: budgetId));
      } else {
        context.read<BudgetsCubit>().getBudgets();
        context.read<BudgetBloc>().add(BudgetBlocInitial());

        return;
      }
    });
  }

  void _getData() {
    context.read<SettingBloc>().add(GetUserSettingEvent());
    context.read<BudgetsCubit>().getBudgets();
    final state = context.read<SettingBloc>().state;
    _getBudgetById(state.lastSeenBudgetId);
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return RefreshIndicator(
      onRefresh: () async {
        _getData();
      },
      child: BlocConsumer<SettingBloc, SettingState>(
        listenWhen: (previous, current) {
          final result = previous.lastSeenBudgetId != current.lastSeenBudgetId;

          return result;
        },
        listener: (context, state) {
          if (state.lastSeenBudgetId != null &&
              state.lastSeenBudgetId!.isNotEmpty) {
            _getBudgetById(state.lastSeenBudgetId);
          }
        },
        builder: (context, state) {
          final lastSeenBudgetIdNullOrEmpty =
              state.lastSeenBudgetId == null || state.lastSeenBudgetId!.isEmpty;

          if (lastSeenBudgetIdNullOrEmpty) {
            return SafeArea(
              child: EmptyHomeContentWithAddBudgetButton(
                loading: state.loading,
              ),
            );
          } else if (state.loading) {
            return SafeArea(
              child: EmptyHomeContent(
                loading: state.loading,
              ),
            );
          } else {
            return SafeArea(
              child: BlocBuilder<BudgetBloc, BudgetState>(
                builder: (context, state) {
                  final loading = state is BudgetLoading;
                  var groupCategories = <GroupCategoryHistory>[];
                  var itemCategoryTransactions = <ItemCategoryTransaction>[];

                  Budget? budget;
                  var totalActualExpense = 0;
                  var totalActualIncome = 0;
                  var totalBudgetExpense = 0;
                  var totalBudgetIncome = 0;
                  // var totalPlanExpense = 0;
                  // var totalPlanIncome = 0;

                  if (state is BudgetError) {
                    return const _ErrorWidget();
                  }

                  /// don't remove this line

                  if (state is GetBudgetsLoaded) {
                    budget = state.budget;
                    totalActualExpense = state.totalActualExpense;
                    totalActualIncome = state.totalActualIncome;
                    // totalPlanIncome = budget?.totalPlanIncome ?? 0;
                    // totalPlanExpense = budget?.totalPlanExpense ?? 0;
                    itemCategoryTransactions =
                        state.itemCategoryTransactionsByBudgetId;

                    context.read<PromptAnalysisCubit>()
                      ..setBudget(budget: budget)
                      ..setTotalActualIncome(
                        totalActualIncome: totalActualIncome,
                      )
                      ..setTotalActualExpense(
                        totalActualExpense: totalActualExpense,
                      )
                      ..setItemCategoryTransactionsByBudgetId(
                        itemCategoryTransactionsByBudgetId:
                            state.itemCategoryTransactionsByBudgetId,
                      );

                    if (budget == null) {
                      return const EmptyHomeContent();
                    }

                    groupCategories = budget.groupCategories!;

                    for (final groupCategory in groupCategories) {
                      for (final itemCategory
                          in groupCategory.itemCategoryHistories) {
                        if (itemCategory.type == 'expense') {
                          totalBudgetExpense += itemCategory.amount;
                        }

                        if (itemCategory.type == 'income') {
                          totalBudgetIncome += itemCategory.amount;
                        }
                      }
                    }
                  }

                  return CustomScrollView(
                    slivers: [
                      SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: SliverAppBarDelegate(
                          minHeight: 80.h,
                          maxHeight: 80.h,
                          child: ColoredBox(
                            color: context.color.surface,
                            child: Column(
                              children: [
                                Padding(
                                  padding: getEdgeInsets(left: 16, right: 16),
                                  child: const AppBarWidget(),
                                ),
                                DefaultTabController(
                                  length: 3,
                                  child: TabBar(
                                    tabAlignment: TabAlignment.center,
                                    labelPadding:
                                        getEdgeInsets(left: 16, right: 16),
                                    controller: _tabController,
                                    labelStyle: textStyle(
                                      context,
                                      StyleType.bodMd,
                                    ).copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    tabs: [
                                      Tab(
                                        text: localize.overview,
                                      ),
                                      Tab(
                                        text: localize.tracking,
                                      ),
                                      Tab(
                                        text: localize.insight,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (loading)
                        const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                      if (!loading && budget != null)
                        SliverFillRemaining(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              OverView(
                                groupCategoryHistories: groupCategories,
                                budget: budget,
                                totalActualExpense: totalActualExpense,
                                totalBudgetExpense: totalBudgetExpense,
                                totalActualIncome: totalActualIncome,
                                totalBudgetIncome: totalBudgetIncome,
                                itemCategoryTransactions:
                                    itemCategoryTransactions,
                                user: widget.user,
                              ),
                              TrackingView(
                                budgetId: budget.id,
                              ),
                              InsightView(
                                budgetId: budget.id,
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return Center(
      child: AppText(
        text: localize.failedToLoadDataFromDatabase,
        style: StyleType.bodLg,
      ),
    );
  }
}
