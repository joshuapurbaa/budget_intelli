import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/category_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:budget_intelli/features/transactions/transactions_barrel.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({
    super.key,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _spendOnController = TextEditingController();
  final _itemCategoryController = TextEditingController();
  final _focusSpendOn = FocusNode();
  String transactionType = 'expense';
  String hintText = '';
  ItemCategoryHistory? _selectedItemCategory;
  DateTime? _selectedDate;
  bool calendarOpened = false;
  String? _remainingStr;
  Account? _selectedAccount;

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    _spendOnController.dispose();
    _focusSpendOn.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    _reset();
    context.read<SettingBloc>().add(GetUserSettingEvent());
    context.read<AccountBloc>().add(GetAccountsEvent());
  }

  bool myInterceptor(_, RouteInfo info) {
    context.pop();
    return true;
  }

  void _getItemCategoriesByBudgetId(String budgetId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackingCubit>().getItemCategoriesByBudgetId(
            budgetId,
          );
    });
  }

  void _getAllItemCategoryTransactions(String budgetId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackingCubit>()
        ..getItemCategoriesByBudgetId(budgetId)
        ..getAllItemCategoryTransactionsByBudgetId(budgetId);
      context.read<BudgetBloc>().add(GetBudgetsByIdEvent(id: budgetId));
    });
  }

  void _onTransactionSuccess(AddExpenseTransactionSuccess state) {
    final settingState = context.read<SettingBloc>().state;
    final premium = settingState.user?.premium ?? false;

    if (premium) {
      _insertTransactionToFirestore(state);
    } else {
      _afterSuccess(state.budgetId);
    }
  }

  Future<void> _insertTransactionToFirestore(
    AddExpenseTransactionSuccess state,
  ) async {
    await context
        .read<BudgetFirestoreCubit>()
        .insertItemCategoryTransactionToFirestore(
          itemCategoryTransaction: state.itemCategoryTransaction,
          selectedAccount: state.selectedAccount,
          amount: state.amount,
        );
  }

  void _afterSuccess(String budgetId) {
    final localize = textLocalizer(context);
    context.pop();

    AppToast.showToastSuccess(
      context,
      localize.createdSuccessFully,
    );

    _getAllItemCategoryTransactions(budgetId);

    _reset();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final textDate = AppText(
      text: _selectedDate == null
          ? '${localize.dateFieldLabel}*'
          : formatDateDDMMYYYY(_selectedDate!, context),
      style: StyleType.bodMd,
      fontWeight: _selectedDate == null ? FontWeight.w400 : FontWeight.w700,
      color: _selectedDate == null
          ? context.color.onSurface.withOpacity(0.5)
          : context.color.onSurface,
    );
    if (transactionType == 'expense') {
      hintText = '${localize.whereDidYouSpendThisMoney}*';
    } else {
      hintText = '${localize.receiptMethod}?*';
    }

    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, settingState) {
        final budgetId = settingState.lastSeenBudgetId;
        final userIntelli = settingState.user;

        final premiumUser = userIntelli?.premium ?? false;

        if (budgetId != null) {
          _getItemCategoriesByBudgetId(budgetId);
        }
        return Scaffold(
          bottomSheet: BottomSheetParent(
            isWithBorderTop: true,
            child: BlocConsumer<TransactionsCubit, TransactionsState>(
              listener: (context, state) {
                if (state is AddExpenseTransactionSuccess) {
                  _onTransactionSuccess(state);
                }

                if (state is AddExpenseTransactionFailed) {
                  context.pop();
                  AppToast.showToastError(
                    context,
                    state.message,
                  );
                }

                if (state is TransactionsLoading) {
                  AppDialog.showLoading(context);
                }
              },
              builder: (context, stateTransaction) {
                return BlocConsumer<BudgetFirestoreCubit, BudgetFirestoreState>(
                  listener: (context, state) {
                    if (state.insertItemCategoryTransactionSuccess) {
                      _afterSuccess(budgetId!);
                    }
                  },
                  builder: (context, state) {
                    final loading = state.loadingFirestore;
                    return loading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : AppButton.darkLabel(
                            label: localize.add,
                            isActive: true,
                            onPressed: () {
                              if (_selectedItemCategory != null) {
                                final idTransaction = const Uuid().v1();
                                final itemId = _selectedItemCategory?.id;
                                final amount =
                                    ControllerHelper.getAmount(context);
                                final groupId =
                                    _selectedItemCategory?.groupHistoryId;

                                final imageBytes =
                                    ControllerHelper.getImagesBytes(
                                  context,
                                );
                                if (itemId != null &&
                                    amount != null &&
                                    _selectedDate != null &&
                                    groupId != null &&
                                    _selectedAccount != null &&
                                    _spendOnController.text.isNotEmpty) {
                                  final selectedAccountId =
                                      _selectedAccount?.id;
                                  final transaction = ItemCategoryTransaction(
                                    id: idTransaction,
                                    itemHistoId: itemId,
                                    categoryName: _selectedItemCategory!.name,
                                    amount: amount,
                                    createdAt: _selectedDate.toString(),
                                    type: transactionType,
                                    spendOn: _spendOnController.text,
                                    budgetId: budgetId!,
                                    picture: imageBytes,
                                    groupId: groupId,
                                    accountId: selectedAccountId!,
                                  );
                                  context
                                      .read<TransactionsCubit>()
                                      .insertItemCategoryTransaction(
                                        itemCategoryTransaction: transaction,
                                        selectedAccount: _selectedAccount!,
                                        amount: amount,
                                        budgetId: budgetId,
                                      );
                                } else {
                                  AppToast.showToastError(
                                    context,
                                    localize.pleaseFillAllRequiredFields,
                                  );
                                }
                              } else {
                                AppToast.showToastError(
                                  context,
                                  localize.pleaseFillAllRequiredFields,
                                );
                              }
                            },
                          );
                  },
                );
              },
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBarPrimary(
                title: '${localize.add} ${localize.transactions}',
              ),
              SliverPadding(
                padding: getEdgeInsetsAll(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Radio.adaptive(
                                value: 'expense',
                                groupValue: transactionType,
                                onChanged: (value) {
                                  setState(() {
                                    transactionType = value.toString();
                                    _selectedItemCategory = null;
                                    _itemCategoryController.clear();
                                    _remainingStr = null;
                                  });
                                },
                              ),
                              Gap.horizontal(8),
                              AppText(
                                text: localize.expenses,
                                style: StyleType.bodMd,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio.adaptive(
                                value: 'income',
                                groupValue: transactionType,
                                onChanged: (value) {
                                  setState(() {
                                    transactionType = value.toString();
                                    _selectedItemCategory = null;
                                    _itemCategoryController.clear();
                                    _remainingStr = null;
                                  });
                                },
                              ),
                              Gap.horizontal(8),
                              AppText(
                                text: localize.income,
                                style: StyleType.bodMd,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gap.vertical(10),
                      BlocBuilder<TrackingCubit, TrackingState>(
                        builder: (context, state) {
                          var itemCategories = <ItemCategoryHistory>[];

                          if (transactionType == 'expense') {
                            itemCategories = state.itemCategories
                                .where((element) => element.type == 'expense')
                                .toList();
                          } else {
                            itemCategories = state.itemCategories
                                .where((element) => element.type == 'income')
                                .toList();
                          }

                          return AppGlass(
                            // height: 70.h,
                            padding: getEdgeInsets(
                              top: 10,
                              bottom: 10,
                              left: 16,
                              right: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownMenu<ItemCategoryHistory>(
                                  controller: _itemCategoryController,
                                  expandedInsets: EdgeInsets.zero,
                                  menuHeight: 150.h,
                                  selectedTrailingIcon: const Icon(
                                    CupertinoIcons.chevron_up,
                                    size: 25,
                                  ),
                                  leadingIcon: Padding(
                                    padding: getEdgeInsets(right: 22),
                                    child: getPngAsset(
                                      categoryPng,
                                      height: 18,
                                      width: 18,
                                      color: context.color.onSurface,
                                    ),
                                  ),
                                  inputDecorationTheme:
                                      _inputDecoration(context),
                                  trailingIcon: const Icon(
                                    CupertinoIcons.chevron_down,
                                    size: 25,
                                  ),
                                  hintText: '${localize.selectCategory}*',
                                  textStyle: textStyle(
                                    context,
                                    StyleType.bodMd,
                                  ).copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  requestFocusOnTap: false,
                                  onSelected:
                                      (ItemCategoryHistory? category) async {
                                    await _calculateTransactions(category);
                                  },
                                  menuStyle: _menuStyle(),
                                  dropdownMenuEntries: itemCategories.map<
                                      DropdownMenuEntry<ItemCategoryHistory>>(
                                    (ItemCategoryHistory itemCategory) {
                                      final path = itemCategory.iconPath;
                                      return DropdownMenuEntry<
                                          ItemCategoryHistory>(
                                        leadingIcon: path != null
                                            ? getPngAsset(
                                                path,
                                                height: 20,
                                                width: 20,
                                                // color: context.color.onSurface,
                                              )
                                            : Icon(
                                                CupertinoIcons.photo,
                                                color: context.color.primary,
                                                size: 18,
                                              ),
                                        value: itemCategory,
                                        label: itemCategory.name,
                                        style: MenuItemButton.styleFrom(
                                          visualDensity:
                                              VisualDensity.comfortable,
                                          textStyle: textStyle(
                                            context,
                                            StyleType.bodMd,
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                                if (_remainingStr != null) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${localize.left2}: ',
                                            style: textStyle(
                                              context,
                                              StyleType.bodSm,
                                            ),
                                          ),
                                          TextSpan(
                                            text: _remainingStr ?? '',
                                            style: textStyle(
                                              context,
                                              StyleType.bodSm,
                                            ).copyWith(
                                              color: context.color.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                      Gap.vertical(10),
                      GestureDetector(
                        onTap: _showCalendar,
                        child: AppGlass(
                          height: 70.h,
                          child: Row(
                            children: [
                              getSvgAsset(
                                dateCalender,
                                color: context.color.onSurface,
                              ),
                              Gap.horizontal(16),
                              Expanded(
                                child: textDate,
                              ),
                              Gap.horizontal(16),
                              Icon(
                                calendarOpened
                                    ? CupertinoIcons.chevron_up
                                    : CupertinoIcons.chevron_down,
                                size: 25,
                              ),
                              Gap.horizontal(10),
                            ],
                          ),
                        ),
                      ),
                      Gap.vertical(10),
                      AppBoxFormField(
                        hintText: hintText,
                        prefixIcon: noteDescriptionPng,
                        controller: _spendOnController,
                        focusNode: _focusSpendOn,
                        isPng: true,
                        iconColor: context.color.onSurface,
                      ),
                      Gap.vertical(10),
                      BlocBuilder<AccountBloc, AccountState>(
                        builder: (context, state) {
                          final accounts = state.accounts;
                          return Row(
                            children: [
                              Expanded(
                                child: AppGlass(
                                  height: 70.h,
                                  padding: getEdgeInsets(
                                    top: 10,
                                    bottom: 10,
                                    left: 16,
                                    right: 10,
                                  ),
                                  child: DropdownMenu<Account>(
                                    expandedInsets: EdgeInsets.zero,
                                    menuHeight: 150.h,
                                    selectedTrailingIcon: const Icon(
                                      CupertinoIcons.chevron_up,
                                      size: 25,
                                    ),
                                    leadingIcon: Padding(
                                      padding: getEdgeInsets(right: 22),
                                      child: getPngAsset(
                                        accountPng,
                                        height: 18,
                                        width: 18,
                                        color: context.color.onSurface,
                                      ),
                                    ),
                                    inputDecorationTheme:
                                        _inputDecoration(context),
                                    trailingIcon: const Icon(
                                      CupertinoIcons.chevron_down,
                                      size: 25,
                                    ),
                                    hintText: '${localize.selectAccount}*',
                                    textStyle: textStyle(
                                      context,
                                      StyleType.bodMd,
                                    ).copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    requestFocusOnTap: false,
                                    onSelected: (Account? account) {
                                      setState(() {
                                        _selectedAccount = account;
                                      });
                                    },
                                    menuStyle: _menuStyle(),
                                    dropdownMenuEntries: accounts
                                        .map<DropdownMenuEntry<Account>>(
                                      (Account account) {
                                        return DropdownMenuEntry<Account>(
                                          value: account,
                                          label: account.name,
                                          style: MenuItemButton.styleFrom(
                                            visualDensity:
                                                VisualDensity.comfortable,
                                            textStyle: textStyle(
                                              context,
                                              StyleType.bodMd,
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ),
                              Gap.horizontal(5),
                              GestureDetector(
                                onTap: () {
                                  context.push(
                                    MyRoute.addAccountScreen,
                                  );
                                },
                                child: AppGlass(
                                  height: 70.h,
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Gap.vertical(10),
                      BoxCalculator(
                        label: '${localize.amountFieldLabel}*',
                      ),
                      Gap.vertical(10),
                      BlocBuilder<TransactionsCubit, TransactionsState>(
                        builder: (context, state) {
                          var created = false;
                          if (state is AddExpenseTransactionSuccess) {
                            created = true;
                          } else {
                            created = false;
                          }
                          return AppBoxUploadImage(
                            created: created,
                          );
                        },
                      ),
                      if (!premiumUser) ...[
                        Gap.vertical(10),
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
                      Gap.vertical(90),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _calculateTransactions(ItemCategoryHistory? category) async {
    if (category?.id != null) {
      final transactions =
          await context.read<CategoryCubit>().getItemCategoryTransactions(
                itemId: category?.id ?? '',
              );

      var spent = 0;
      final amount = category?.amount;

      if (transactions.isNotEmpty) {
        spent = transactions.map((e) => e.amount).reduce(
              (value, element) => value + element,
            );
      }
      setState(() {
        if (amount != null) {
          _remainingStr =
              NumberFormatter.formatToMoneyInt(context, amount - spent);
        }
        _selectedItemCategory = category;
      });
    }
  }

  Future<void> _showCalendar() async {
    final localize = textLocalizer(context);

    setState(() {
      calendarOpened = !calendarOpened;
    });

    final result = await showAdaptiveDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final firstDate = DateTime.now().subtract(const Duration(days: 365));
        final lastDate = DateTime.now().add(const Duration(days: 365));
        return DatePickerDialog(
          firstDate: firstDate,
          lastDate: lastDate,
          confirmText: localize.select,
          cancelText: localize.cancel,
          helpText: localize.selectDate,
        );
      },
    );

    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;

    if (result != null) {
      if (result.year == now.year &&
          result.month == now.month &&
          result.day == now.day) {
        _selectedDate = DateTime(
          result.year,
          result.month,
          result.day,
          hour,
          minute,
        );
      } else {
        _selectedDate = DateTime(
          result.year,
          result.month,
          result.day,
        );
      }

      setState(() {
        calendarOpened = false;
      });
    } else {
      setState(() {
        calendarOpened = false;
      });
    }
  }

  MenuStyle _menuStyle() {
    return MenuStyle(
      visualDensity: VisualDensity.standard,
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  InputDecorationTheme _inputDecoration(
    BuildContext context,
  ) {
    return InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: textStyle(
        context,
        StyleType.bodMd,
      ).copyWith(
        fontWeight: FontWeight.w400,
        color: context.color.onSurface.withOpacity(0.5),
      ),
    );
  }

  void _reset() {
    _spendOnController.clear();
    _focusSpendOn.unfocus();
    context.read<BoxCalculatorCubit>().unselect();
    context.read<UploadImageBloc>().add(ResetImage());
    context
        .read<BoxCalendarCubit>()
        .setToInitial(CalendarDatePicker2Type.single);
    context.read<TransactionsCubit>().setToInitial();
    context.read<BudgetFirestoreCubit>().resetState();
  }
}
