import 'dart:async';

import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/budget/view/widgets/budget_form_field_initial.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class InitialCreateBudgetPlanScreen extends StatefulWidget {
  const InitialCreateBudgetPlanScreen({super.key});

  @override
  State<InitialCreateBudgetPlanScreen> createState() =>
      _InitialCreateBudgetPlanScreenState();
}

class _InitialCreateBudgetPlanScreenState
    extends State<InitialCreateBudgetPlanScreen> {
  final _scrollController = ScrollController();
  final _budgetNameController = TextEditingController();
  final _budgetNameFocus = FocusNode();
  final budgetID = const Uuid().v1();
  final users = FirebaseFirestore.instance.collection('users');
  StreamSubscription<DocumentSnapshot>? userSubscription;

  // late StreamSubscription<List<PurchaseDetails>> _iapSubscription;

  @override
  void initState() {
    super.initState();
    _showOptionCreateBudget();
    _initData();
    _getUserData();
    // _initializeIAP();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _validateAiCreateBudgetFeature({
    required bool validated,
  }) async {
    if (validated) {
      final result = await context.pushNamed<String>(
        MyRoute.budgetAiGenerateScreen.noSlashes(),
      );

      if (result != null) {
        setState(() {
          _budgetNameController.text = result;
        });
      }
    } else {
      AppToast.showToastError(
        context,
        textLocalizer(context).requestLimitExceeded,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, settingState) {
        if (settingState.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        var premium = false;

        if (settingState.user != null) {
          premium = settingState.user?.premium ?? false;
        }

        return BlocConsumer<BudgetFormBloc, BudgetFormState>(
          listenWhen: (previous, current) {
            return previous.insertBudgetSuccess != current.insertBudgetSuccess;
          },
          listener: (context, state) {
            if (state.insertBudgetSuccess) {
              _onSuccessInsertBudget(state, context);
            } else {
              AppToast.showToastError(
                context,
                localize.failedToSave,
              );
              _budgetNameFocus.unfocus();
            }
          },
          builder: (context, state) {
            final (firstTitle, secondTitle) = _setTitle(state);
            const groupNameInitialEN = 'Group Name';
            const groupNameInitialID = 'Nama Grup';
            const categoryNameInitialEN = 'Category Name';
            const categoryNameInitialID = 'Nama Kategori';
            final onSurfaceColor = context.color.onSurface.withOpacity(0.5);

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
                              StyleType.headMed,
                            ),
                          ),
                          TextSpan(
                            text: ' $secondTitle',
                            style: textStyle(
                              context,
                              StyleType.bodMd,
                            ).copyWith(
                              fontStyle: FontStyle.italic,
                              color: onSurfaceColor,
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
                      bottom: 8,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final prefsAi = AiAssistantPreferences();
                              final totalGenerateBudget =
                                  await prefsAi.getTotalGenerateBudget();

                              await _validateAiCreateBudgetFeature(
                                validated: totalGenerateBudget <= 2,
                              );
                            },
                            child: AppGlass(
                              margin: getEdgeInsets(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    text: localize.generateWithAI,
                                    style: StyleType.bodLg,
                                    textAlign: TextAlign.center,
                                  ),
                                  Gap.horizontal(16),
                                  const Icon(
                                    CupertinoIcons.chevron_right,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AppBoxFormField(
                            hintText: localize.budgetName,
                            prefixIcon: budgetPng,
                            controller: _budgetNameController,
                            focusNode: _budgetNameFocus,
                            isPng: true,
                          ),
                          Gap.vertical(8),
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
                              final width =
                                  MediaQuery.sizeOf(context).width * 0.9;

                              final results =
                                  await showCalendarDatePicker2Dialog(
                                context: context,
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(
                                  calendarType: CalendarDatePicker2Type.range,
                                  firstDate: now,
                                  controlsTextStyle: textStyle(
                                    context,
                                    StyleType.bodLg,
                                  ),
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
                                        ? onSurfaceColor
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
                    BudgetFormFieldInitial(
                      fromInitial: true,
                      budgetId: budgetID,
                      groupCategories: state.groupCategoryHistories,
                      portions: state.portions,
                    ),
                  SliverPadding(
                    padding: getEdgeInsetsSymmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          BlocConsumer<BudgetFirestoreCubit,
                              BudgetFirestoreState>(
                            listener: (context, fireState) {
                              if (fireState.insertBudgetToFirestoreSuccess) {
                                AppToast.showToastSuccess(
                                  context,
                                  localize.saveSuccessfully,
                                );
                                _onGoToMain();
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

                                  final groupHistoLen =
                                      state.groupCategoryHistories.length;
                                  final groupCategoryHistory =
                                      <GroupCategoryHistory>[];
                                  final itemCategoriesParams =
                                      <ItemCategoryHistory>[];

                                  for (var i = 0; i < groupHistoLen; i++) {
                                    final itemCategories = state
                                        .groupCategoryHistories[i]
                                        .itemCategoryHistories
                                        .length;

                                    final groupHistory =
                                        state.groupCategoryHistories[i];

                                    final groupName = groupHistory.groupName;

                                    if (groupName.isEmpty ||
                                        groupName == groupNameInitialEN ||
                                        groupName == groupNameInitialID) {
                                      AppToast.showToastError(
                                        context,
                                        localize.groupNameCannotBeEmpty,
                                        gravity: ToastGravity.CENTER,
                                      );
                                      return;
                                    }

                                    final params = GroupCategoryHistory(
                                      id: groupHistory.id,
                                      groupName: groupHistory.groupName,
                                      method: groupHistory.method,
                                      type: groupHistory.type,
                                      budgetId: budgetID,
                                      groupId: groupHistory.groupId,
                                      createdAt: groupHistory.createdAt,
                                      updatedAt: groupHistory.createdAt,
                                      hexColor: groupHistory.hexColor,
                                    );

                                    groupCategoryHistory.add(params);

                                    for (var j = 0; j < itemCategories; j++) {
                                      final item =
                                          groupHistory.itemCategoryHistories[j];
                                      final itemName = item.name;

                                      if (itemName.isEmpty ||
                                          itemName == categoryNameInitialID ||
                                          itemName == categoryNameInitialEN ||
                                          item.amount == 0) {
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
                                        groupHistoryId: groupHistory.id,
                                        itemId: item.itemId,
                                        amount: item.amount,
                                        type: item.type,
                                        createdAt: item.createdAt,
                                        isExpense: item.isExpense,
                                        budgetId: budgetID,
                                        groupName: groupName,
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

                                  final startDate =
                                      selectedRangeDate[0].toString();
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

                                  context.read<PromptCubit>().resetPrompt();

                                  context.read<BudgetFormBloc>().add(
                                        InsertBudgetsToDatabase(
                                          groupCategoryHistories:
                                              groupCategoryHistory,
                                          itemCategoryHistories:
                                              itemCategoriesParams,
                                          budget: budget,
                                          fromInitial: true,
                                        ),
                                      );
                                },
                              );
                            },
                          ),
                          // Gap.vertical(16),
                          // if (!premium)
                          //   AppButton(
                          //     label: localize.buyPremium,
                          //     onPressed: () {
                          //       _showPremiumModalBottom(settingState.user);
                          //     },
                          //   ),
                          if (!premium) ...[
                            // Gap.vertical(32),
                            // AppButton(
                            //   label: localize.buyPremium,
                            //   onPressed: () {
                            //     _showPremiumModalBottom(userIntelli);
                            //   },
                            // ),
                            Gap.vertical(8),
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _getUserData() async {
    final userId = await context.read<PreferenceCubit>().getUserUid();
    if (userId != null) {
      userSubscription = users.doc(userId).snapshots().listen(
        (event) {
          final documentData = event.data();
          final user = UserIntelli.fromMap(documentData);
          _onSuccessAuth(user);
        },
      );
    } else {
      if (!mounted) return;
      context.read<SettingBloc>().add(GetUserSettingEvent());
    }
  }

  void _initData() {
    context.read<BudgetFormBloc>().add(
          BudgetFormInitial(generateBudgetAI: false),
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

  Future<void> _onSuccessInsertBudget(
    BudgetFormState state,
    BuildContext context,
  ) async {
    context.read<SettingBloc>()
      ..add(SetUserLastSeenBudgetId(lastSeenBudgetId: budgetID))
      ..add(
        SetUserAlreadySetInitialCreateBudget(
          alreadySetInitialCreateBudget: true,
        ),
      );
    await _insertToFirestore(
      state,
      context,
    );
  }

  Future<void> _insertToFirestore(
    BudgetFormState state,
    BuildContext context,
  ) async {
    final localize = textLocalizer(context);
    final settingState = context.read<SettingBloc>().state;
    final userIntellie = settingState.user;
    final premium = userIntellie?.premium ?? false;
    if (premium) {
      await context.read<BudgetFirestoreCubit>().insertBudgetToFirestore(
            groupCategoryHistoriesParams: state.groupCategoryHistoriesParams,
            itemCategoryHistoriesParams: state.itemCategoryHistoriesParams,
            budgetParams: state.budgetParams!,
            fromInitial: true,
            user: userIntellie,
            fromSync: false,
          );
    } else {
      AppToast.showToastSuccess(
        context,
        localize.saveSuccessfully,
      );
      _onGoToMain();
    }
  }

  void _onSuccessAuth(UserIntelli? user) {
    if (user != null) {
      context.read<SettingBloc>()
        ..add(SetUserIntelli(user))
        ..add(SetUserIsLoggedIn(isLoggedIn: true))
        ..add(SetUserName(user.name))
        ..add(SetUserEmail(user.email))
        ..add(SetUserUidEvent(user.uid))
        ..add(SetUserIsPremiumUser(isPremiumUser: user.premium ?? false))
        ..add(GetUserSettingEvent());
    }
  }

  void _showPremiumModalBottom(UserIntelli? user) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height - statusBarHeight,
      ),
      builder: (context) {
        return PremiumModal(
          user: user,
        );
      },
    );
  }

  void _showOptionCreateBudget() {
    if (enableAI) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final result = await showDialog<String?>(
          context: context,
          builder: (context) {
            return const CreateBudgetOptionDialog();
          },
        );

        if (result != null) {
          setState(() {
            _budgetNameController.text = result;
          });
        }
      });
    }
  }

  void _onGoToMain() {
    context.read<BudgetBloc>().add(GetBudgetsByIdEvent(id: budgetID));

    context.go(MyRoute.main);
  }

  // void _initializeIAP() {
  //   final purchaseUpdated = InAppPurchase.instance.purchaseStream;
  //
  //   _iapSubscription = purchaseUpdated.listen(
  //     (purchaseDetailsList) {
  //       context.read<UserFirestoreCubit>().listenToPurchaseUpdated(
  //             purchaseDetailsList,
  //           );
  //     },
  //     onDone: () {
  //       print('on done iap');
  //       _iapSubscription.cancel();
  //     },
  //     onError: (error) {
  //       print('on error iap');
  //       _iapSubscription.cancel();
  //     },
  //   );
  // }

  (String, String) _setTitle(BudgetFormState state) {
    final localize = textLocalizer(context);
    String? firstTitle;
    String? secondTitle;
    if (_scrollController.hasClients && _scrollController.offset > 0) {
      if (state.totalBalance == 0 &&
          state.totalPlanExpense != 0 &&
          state.totalPlanIncome != 0) {
        firstTitle = localize.allAssigned;
        secondTitle = '';
        return (firstTitle, secondTitle);
      } else {
        if (state.totalBalance != null) {
          if (state.totalBalance! < 0) {
            final money = NumberFormatter.formatToMoneyDouble(
              context,
              state.totalBalance ?? 0,
            );
            firstTitle = money;
            secondTitle = localize.exceedsBudget;
            return (firstTitle, secondTitle);
          } else {
            final money = NumberFormatter.formatToMoneyDouble(
              context,
              state.totalBalance ?? 0,
            );
            firstTitle = money;
            secondTitle = localize.notAssignedYet;
            return (firstTitle, secondTitle);
          }
        } else {
          firstTitle = localize.budgetPlan;
          secondTitle = '';
          return (firstTitle, secondTitle);
        }
      }
    } else {
      firstTitle = localize.budgetPlan;
      secondTitle = '';
      return (firstTitle, secondTitle);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _budgetNameController.dispose();
    userSubscription?.cancel();
    // _iapSubscription.cancel();
    _budgetNameFocus.dispose();
    super.dispose();
  }
}
