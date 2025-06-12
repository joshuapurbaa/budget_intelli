import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/category_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddNewBudgetScreen extends StatefulWidget {
  const AddNewBudgetScreen({super.key});

  @override
  State<AddNewBudgetScreen> createState() => _AddNewBudgetScreenState();
}

class _AddNewBudgetScreenState extends State<AddNewBudgetScreen> {
  final _scrollController = ScrollController();
  final _budgetNameController = TextEditingController();
  final _budgetNameFocus = FocusNode();
  final String budgetID = const Uuid().v1();

  @override
  void initState() {
    super.initState();
    _initData();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  void _initData() {
    context.read<BudgetFirestoreCubit>().resetState();
    context.read<PromptCubit>()
      ..resetStatus()
      ..resetPrompt();
    context.read<CategoryCubit>()
      ..getGroupCategories()
      ..getItemCategories();
    context.read<BudgetFormBloc>().add(
          BudgetFormNew(
            generateBudgetAI: false,
          ),
        );
  }

  void _selectDateRange(List<DateTime?> results) {
    if (results.isNotEmpty) {
      context.read<BudgetFormBloc>().add(
            SelectDateRange(
              dateRange: results,
            ),
          );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _budgetNameController.dispose();
    _budgetNameFocus.dispose();
    super.dispose();
  }

  Future<void> _onSuccessInsertBudget(
    BudgetFormState state,
    BuildContext context,
  ) async {
    context.read<SettingBloc>().add(
          SetUserLastSeenBudgetId(lastSeenBudgetId: budgetID),
        );
    await _insertToFirestore(state, context);
  }

  Future<void> _insertToFirestore(
    BudgetFormState state,
    BuildContext context,
  ) async {
    final settingState = context.read<SettingBloc>().state;
    final premium = settingState.premiumUser;
    if (premium) {
      await context.read<BudgetFirestoreCubit>().insertBudgetToFirestore(
            groupCategoryHistoriesParams: state.groupCategoryHistoriesParams,
            itemCategoryHistoriesParams: state.itemCategoryHistoriesParams,
            budgetParams: state.budgetParams!,
            itemCategories: state.itemCategoriesParams,
            groupCategoriesParams: state.groupCategoriesParams,
            fromInitial: false,
            user: settingState.user,
            fromSync: false,
          );
      _back();
    } else {
      _back();
    }
  }

  void _back() {
    final localize = textLocalizer(context);
    AppToast.showToastSuccess(
      context,
      localize.saveSuccessfully,
    );
    context.read<CategoryCubit>().resetState();
    context.read<BudgetFirestoreCubit>().resetState();
    context.read<BudgetBloc>().add(GetBudgetsByIdEvent(id: budgetID));

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return BlocConsumer<BudgetFormBloc, BudgetFormState>(
      listenWhen: (previous, current) {
        return previous.insertBudgetSuccess != current.insertBudgetSuccess;
      },
      listener: (context, state) {
        if (state.insertBudgetSuccess) {
          _onSuccessInsertBudget(
            state,
            context,
          );
        } else {
          AppToast.showToastError(
            context,
            localize.failedToSave,
          );
          _budgetNameFocus.unfocus();
        }
      },
      builder: (context, state) {
        String? firstTitle;
        String? secondTitle;
        if (_scrollController.hasClients && _scrollController.offset > 0) {
          if (state.totalBalance == 0 &&
              state.totalPlanExpense != 0 &&
              state.totalPlanIncome != 0) {
            firstTitle = localize.allAssigned;
            secondTitle = '';
          } else {
            if (state.totalBalance != null) {
              if (state.totalBalance! < 0) {
                final money = NumberFormatter.formatToMoneyDouble(
                  context,
                  state.totalBalance ?? 0,
                );
                firstTitle = money;
                secondTitle = localize.exceedsBudget;
              } else {
                final money = NumberFormatter.formatToMoneyDouble(
                  context,
                  state.totalBalance ?? 0,
                );
                firstTitle = money;
                secondTitle = localize.notAssignedYet;
              }
            } else {
              firstTitle = localize.budgetPlan;
              secondTitle = '';
            }
          }
        } else {
          firstTitle = localize.budgetPlan;
          secondTitle = '';
        }

        const groupNameInitialEN = 'Group Name';
        const groupNameInitialID = 'Nama Grup';
        const categoryNameInitialEN = 'Category Name';
        const categoryNameInitialID = 'Nama Kategori';

        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                centerTitle: true,
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: firstTitle,
                        style: textStyle(
                          context,
                          style: StyleType.headMed,
                        ),
                      ),
                      TextSpan(
                        text: ' $secondTitle',
                        style: textStyle(
                          context,
                          style: StyleType.bodMd,
                        ).copyWith(
                          fontStyle: FontStyle.italic,
                          color: context.color.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                floating: true,
                pinned: true,
              ),
              SliverPadding(
                padding: getEdgeInsets(
                  left: 16,
                  top: 16,
                  right: 16,
                  bottom: 10,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // GestureDetector(
                      //   onTap: () async {
                      //     if (enableAI) {
                      //       final result = await context.push<String>(
                      //         RouteName.budgetAiGenerateScreen,
                      //       );

                      //       if (result != null) {
                      //         setState(() {
                      //           _budgetNameController.text = result;
                      //         });
                      //       }
                      //     } else {
                      //       AppToast.showToastError(
                      //         context,
                      //         localize.aiIsNotAvailableYet,
                      //       );
                      //     }
                      //   },
                      //   child: AppGlass(
                      //     margin: getEdgeInsets(bottom: 10),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         AppText(
                      //           text: localize.generateWithAI,
                      //           style: StyleType.bodLg,
                      //           textAlign: TextAlign.center,
                      //         ),
                      //         Gap.horizontal(16),
                      //         const Icon(
                      //           CupertinoIcons.chevron_right,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // ),
                      AppBoxFormField(
                        hintText: localize.budgetName,
                        prefixIcon: budgetPng,
                        controller: _budgetNameController,
                        focusNode: _budgetNameFocus,
                        isPng: true,
                      ),
                      Gap.vertical(10),
                      // AppGlass(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       AppText(
                      //         text: '${localize.totalPlannedIncome}: ',
                      //         style: StyleType.bodMd,
                      //         fontWeight: FontWeight.w700,
                      //       ),
                      //       AutoSizeText(
                      //         NumberFormatter.formatToMoneyInt(
                      //           context,
                      //           state.totalPlanIncome,
                      //         ),
                      //         style: textStyle(
                      //           context,
                      //           StyleType.bodLg,
                      //         ),
                      //         maxLines: 1,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Gap.vertical(10),
                      GestureDetector(
                        onTap: () async {
                          _budgetNameFocus.unfocus();
                          final now = DateTime.now();

                          final width = MediaQuery.sizeOf(context).width * 0.9;

                          final results = await showCalendarDatePicker2Dialog(
                            context: context,
                            config: CalendarDatePicker2WithActionButtonsConfig(
                              calendarType: CalendarDatePicker2Type.range,
                              firstDate: now,
                            ),
                            dialogSize: Size(width, 400),
                            value: state.dateRange,
                            borderRadius: BorderRadius.circular(15),
                          );

                          if (results != null && results.length == 2) {
                            _selectDateRange(results);
                          }
                          _budgetNameFocus.unfocus();
                        },
                        child: AppGlass(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                text: formatDateRangeDateList(
                                  state.dateRange,
                                  context,
                                ),
                                style: StyleType.bodMd,
                                textAlign: TextAlign.center,
                                fontWeight: state.dateRange.isEmpty
                                    ? null
                                    : FontWeight.w700,
                                maxLines: 2,
                                color: state.dateRange.isEmpty
                                    ? context.color.onSurface
                                        .withValues(alpha: 0.5)
                                    : context.color.onSurface,
                              ),
                              Gap.horizontal(16),
                              getPngAsset(
                                chevronDownPng,
                                color: context.color.primary,
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.groupCategoryHistories.isNotEmpty)
                BudgetFormField(
                  fromInitial: true,
                  budgetId: budgetID,
                  groupCategoryHistories: state.groupCategoryHistories,
                  portions: state.portions,
                ),
              if (state.groupCategoryHistories.isNotEmpty)
                SliverPadding(
                  padding: getEdgeInsets(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: BlocConsumer<BudgetFirestoreCubit,
                        BudgetFirestoreState>(
                      listener: (context, fireState) {
                        if (fireState.insertBudgetToFirestoreSuccess) {
                          AppToast.showToastSuccess(
                            context,
                            localize.saveSuccessfully,
                          );
                          _back();
                        }
                      },
                      builder: (context, fireState) {
                        if (fireState.loadingFirestore) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        return AppButton(
                          label: localize.save,
                          onPressed: () {
                            if (_budgetNameController.text.isEmpty) {
                              AppToast.showToastError(
                                context,
                                localize.budgetNameCannotBeEmpty,
                                gravity: ToastGravity.CENTER,
                              );
                              return;
                            }
                            final groupCategory =
                                state.groupCategoryHistories.length;
                            final groupCategoryParams =
                                <GroupCategoryHistory>[];
                            final itemCategoriesParams =
                                <ItemCategoryHistory>[];

                            for (var i = 0; i < groupCategory; i++) {
                              final itemCategories = state
                                  .groupCategoryHistories[i]
                                  .itemCategoryHistories
                                  .length;
                              final groupHisto =
                                  state.groupCategoryHistories[i];
                              final groupName = groupHisto.groupName;

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
                                id: groupHisto.id,
                                groupName: groupHisto.groupName,
                                method: groupHisto.method,
                                type: groupHisto.type,
                                groupId: groupHisto.groupId,
                                budgetId: budgetID,
                                createdAt: groupHisto.createdAt,
                                updatedAt: groupHisto.updatedAt,
                                hexColor: groupHisto.hexColor,
                              );

                              groupCategoryParams.add(params);

                              for (var j = 0; j < itemCategories; j++) {
                                final item =
                                    groupHisto.itemCategoryHistories[j];
                                final itemName = item.name;

                                if (itemName.isEmpty ||
                                    itemName == categoryNameInitialID ||
                                    itemName == categoryNameInitialEN ||
                                    item.amount == 0 ||
                                    itemName == localize.selectCategory ||
                                    itemName == localize.typeCategoryName ||
                                    itemName == localize.categoryName) {
                                  AppToast.showToastError(
                                    context,
                                    localize.categoryNameAndAmountCannotBeEmpty,
                                    gravity: ToastGravity.CENTER,
                                  );
                                  return;
                                }

                                final itemCategory = ItemCategoryHistory(
                                  id: item.id,
                                  name: item.name,
                                  groupHistoryId: groupHisto.id,
                                  itemId: item.itemId,
                                  amount: item.amount,
                                  type: item.type,
                                  createdAt: item.createdAt,
                                  isExpense: item.isExpense,
                                  budgetId: budgetID,
                                  groupName: groupHisto.groupName,
                                );

                                itemCategoriesParams.add(itemCategory);
                              }
                            }

                            final selectedRangeDate = state.dateRange;
                            if (selectedRangeDate.isEmpty) {
                              AppToast.showToastError(
                                context,
                                localize.pleaseSelectDateRange,
                                gravity: ToastGravity.CENTER,
                              );
                              return;
                            }

                            final startDate = selectedRangeDate[0].toString();
                            final endDate = selectedRangeDate[1];

                            final endDateStr =
                                '${endDate!.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')} 23:59';

                            var isWeekly = false;
                            var isMonthly = false;

                            // check state.dateRange, if total day is less than 20, then it's weekly
                            if (selectedRangeDate.isNotEmpty) {
                              final startDate = selectedRangeDate[0];
                              final endDate = selectedRangeDate[1];
                              final totalDay =
                                  endDate!.difference(startDate!).inDays;
                              if (totalDay < 25) {
                                isWeekly = true;
                              } else {
                                isMonthly = true;
                              }
                            }

                            final budget = Budget(
                              id: budgetID,
                              budgetName: _budgetNameController.text,
                              createdAt: DateTime.now().toString(),
                              startDate: startDate,
                              endDate: endDateStr,
                              isActive: true,
                              isMonthly: isMonthly,
                              isWeekly: isWeekly,
                              month: selectedRangeDate[0]!.month,
                              year: selectedRangeDate[0]!.year,
                              totalPlanExpense: state.totalPlanExpense,
                              totalPlanIncome: state.totalPlanIncome,
                            );

                            final groupCategories = context
                                .read<CategoryCubit>()
                                .state
                                .groupCategories;
                            final itemCategories = context
                                .read<CategoryCubit>()
                                .state
                                .itemCategories;

                            context.read<PromptCubit>().resetPrompt();

                            context.read<BudgetFormBloc>().add(
                                  InsertBudgetsToDatabase(
                                    groupCategoryHistories: groupCategoryParams,
                                    itemCategoryHistories: itemCategoriesParams,
                                    budget: budget,
                                    groupCategories: groupCategories,
                                    itemCategories: itemCategories,
                                    fromInitial: false,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
