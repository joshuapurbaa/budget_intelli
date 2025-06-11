import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/category_barrel.dart';
import 'package:budget_intelli/features/transactions/transactions_barrel.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddIncomeIncomeTransactionScreen extends StatefulWidget {
  const AddIncomeIncomeTransactionScreen({super.key});

  @override
  State<AddIncomeIncomeTransactionScreen> createState() =>
      _AddIncomeIncomeTransactionScreenState();
}

class _AddIncomeIncomeTransactionScreenState
    extends State<AddIncomeIncomeTransactionScreen> {
  final _spendOnController = TextEditingController();
  final _focusSpendOn = FocusNode();
  Account? _selectedAccount;
  DateTime? _selectedDate;
  bool calendarOpened = false;

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
    context.read<AccountBloc>().add(GetAccountsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final text = AppText(
      text: _selectedDate == null
          ? '${localize.dateFieldLabel}*'
          : formatDateDDMMYYYY(_selectedDate!, context),
      style: StyleType.bodMd,
      fontWeight: _selectedDate == null ? FontWeight.w400 : FontWeight.w700,
      color: _selectedDate == null
          ? context.color.onSurface.withValues(alpha: 0.5)
          : context.color.onSurface,
    );
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, stateCategory) {
        final group = stateCategory.groupCategoryHistories;
        final category = stateCategory.itemCategoryHistory;
        final categoryName = category?.name;
        final iconPath = category?.iconPath;
        final itemId = category?.id;
        final budgeId = stateCategory.budget!.id;

        final isExpense = category?.isExpense ?? false;
        var hintText = '-';
        if (isExpense) {
          hintText = '${localize.whereDidYouSpendThisMoney}*';
        } else {
          hintText = localize.receiptMethod;
        }

        return Scaffold(
          bottomSheet: BottomSheetParent(
            isWithBorderTop: true,
            child: BlocConsumer<TransactionsCubit, TransactionsState>(
              listener: (context, state) {
                if (state is AddExpenseTransactionSuccess) {
                  context.pop();

                  context.read<CategoryCubit>().getItemCategoryTransactions(
                        itemId: itemId!,
                      );

                  context.read<BudgetBloc>().add(
                        GetBudgetsByIdEvent(
                          id: budgeId,
                        ),
                      );
                  _reset();
                  context.pop();
                }

                if (state is UpdateBudgetSuccess) {
                  context.pop();
                  _reset();
                  context.pop();
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
                return AppButton.darkLabel(
                  label: localize.add,
                  isActive: true,
                  onPressed: () {
                    final idTransaction = const Uuid().v1();
                    final itemHistoId = category?.id;
                    final amount = ControllerHelper.getAmount(context);
                    final type = category?.type;
                    final budgetId = group?[0].budgetId;
                    final groupId = category?.groupHistoryId;
                    final imageBytes = ControllerHelper.getImagesBytes(context);

                    if (itemHistoId != null &&
                        amount != null &&
                        _selectedDate != null &&
                        type != null &&
                        budgetId != null &&
                        groupId != null &&
                        _selectedAccount != null &&
                        _spendOnController.text.isNotEmpty) {
                      final selectedAccountId = _selectedAccount?.id;
                      final transaction = ItemCategoryTransaction(
                        id: idTransaction,
                        itemHistoId: itemHistoId,
                        categoryName: categoryName!,
                        amount: amount,
                        createdAt: _selectedDate.toString(),
                        type: type,
                        spendOn: _spendOnController.text,
                        budgetId: budgetId,
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
                            budgetId: budgeId,
                          );
                    } else {
                      AppToast.showToastError(
                        context,
                        localize.pleaseFillAllRequiredFields,
                      );
                    }
                  },
                );
              },
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBarPrimary(
                title: '${localize.add} ${localize.income}',
              ),
              SliverPadding(
                padding: getEdgeInsetsAll(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      AppGlass(
                        height: 70.h,
                        child: Row(
                          children: [
                            if (iconPath != null) ...[
                              SizedBox(
                                width: 25.w,
                                child: Image.asset(
                                  iconPath,
                                  width: 25,
                                ),
                              ),
                              // Gap.horizontal(8),
                            ] else ...[
                              SizedBox(
                                width: 25.w,
                                child: Icon(
                                  CupertinoIcons.photo,
                                  color: context.color.primary,
                                  size: 18,
                                ),
                              ),
                              // Gap.horizontal(8),
                            ],
                            Gap.horizontal(16),
                            AppText(
                              text: categoryName ?? localize.category,
                              style: StyleType.bodMd,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                      Gap.vertical(8),
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
                                child: text,
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
                      Gap.vertical(8),
                      AppBoxFormField(
                        hintText: hintText,
                        prefixIcon: noteDescriptionPng,
                        controller: _spendOnController,
                        focusNode: _focusSpendOn,
                        isPng: true,
                        iconColor: context.color.onSurface,
                      ),
                      Gap.vertical(8),
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
                                    inputDecorationTheme: InputDecorationTheme(
                                      border: InputBorder.none,
                                      hintStyle: textStyle(
                                        context,
                                        StyleType.bodMd,
                                      ).copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: context.color.onSurface
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
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
                                    menuStyle: MenuStyle(
                                      visualDensity: VisualDensity.standard,
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
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
                      Gap.vertical(8),
                      BoxCalculator(
                        label: '${localize.amountFieldLabel}*',
                      ),
                      Gap.vertical(8),
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

  void _reset() {
    _spendOnController.clear();
    _focusSpendOn.unfocus();
    context.read<BoxCalculatorCubit>().unselect();
    context.read<UploadImageBloc>().add(ResetImage());
    context
        .read<BoxCalendarCubit>()
        .setToInitial(CalendarDatePicker2Type.single);
    context.read<TransactionsCubit>().setToInitial();
  }

  bool myInterceptor(dynamic _, RouteInfo info) {
    context.pop();
    return true;
  }
}
