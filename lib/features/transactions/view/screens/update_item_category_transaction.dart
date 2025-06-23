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

class UpdateItemCategoryTransactionScreen extends StatefulWidget {
  const UpdateItemCategoryTransactionScreen({super.key});

  @override
  State<UpdateItemCategoryTransactionScreen> createState() =>
      _UpdateItemCategoryTransactionScreenState();
}

class _UpdateItemCategoryTransactionScreenState
    extends State<UpdateItemCategoryTransactionScreen> {
  final _spendOnController = TextEditingController();
  final _accountController = TextEditingController();
  final _focusSpendOn = FocusNode();
  Account? _selectedAccount;

  @override
  void dispose() {
    _spendOnController.dispose();
    _focusSpendOn.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _reset();
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountBloc>().add(GetAccountsEvent());
      final state = context.read<CategoryCubit>().state;
      final transaction = state.itemCategoryTransaction;
      final createdAtStr = transaction?.createdAt;

      if (transaction != null) {
        if (createdAtStr != null) {
          final createdAt = DateTime.parse(createdAtStr);
          context.read<BoxCalculatorCubit>().select(
                transaction.amount.toString(),
                onUpdateFromState: true,
              );
          _spendOnController.text = transaction.spendOn;
          context.read<BoxCalendarCubit>().selectSingleDate(
            [createdAt],
          );
          context.read<UploadImageBloc>().add(
                OnUpdatedTransactions(
                  transaction.picture,
                  fromLocal: true,
                ),
              );
        }
      }

      final account = state.account;
      if (account != null) {
        setState(() {
          _selectedAccount = account;
          _accountController.text = account.name;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, stateCategory) {
        final transaction = stateCategory.itemCategoryTransaction;
        final budget = stateCategory.budget;
        final category = stateCategory.itemCategoryHistory;
        final categoryName = category?.name;
        final itemId = category?.id;
        final picture = transaction?.picture;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBarPrimary(
                title: localize.update,
              ),
              SliverFillRemaining(
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 0,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          BoxCalculator(
                            label: localize.amountFieldLabel,
                          ),
                          Gap.vertical(8),
                          const BoxCalender(
                            categoriesType: CategoriesType.expenses,
                            calendarType: CalendarDatePicker2Type.single,
                          ),
                          Gap.vertical(8),
                          AppBoxFormField(
                            hintText: '${localize.whereDidYouSpendThisMoney}*',
                            prefixIcon: noteDescriptionPng,
                            controller: _spendOnController,
                            focusNode: _focusSpendOn,
                            isPng: true,
                            iconColor: context.color.onSurface,
                          ),
                          Gap.vertical(8),
                          AppGlass(
                            child: Row(
                              children: [
                                getPngAsset(
                                  categoryPng,
                                  height: 20,
                                  width: 20,
                                  color: context.color.onSurface,
                                ),
                                Gap.horizontal(16),
                                AppText(
                                  text: categoryName ?? localize.category,
                                  style: StyleType.bodMed,
                                ),
                              ],
                            ),
                          ),
                          Gap.vertical(8),
                          BlocBuilder<AccountBloc, AccountState>(
                            builder: (context, state) {
                              final accounts = state.accounts;
                              return Row(
                                children: [
                                  Expanded(
                                    child: AppGlass(
                                      padding: getEdgeInsets(
                                        top: 2,
                                        bottom: 2,
                                        left: 16,
                                        right: 10,
                                      ),
                                      child: DropdownMenu<Account>(
                                        controller: _accountController,
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
                                            InputDecorationTheme(
                                          border: InputBorder.none,
                                          hintStyle: textStyle(
                                            context,
                                            style: StyleType.bodMed,
                                          ).copyWith(
                                            fontWeight: FontWeight.w400,
                                            color:
                                                context.color.onSurfaceVariant,
                                          ),
                                        ),
                                        trailingIcon: const Icon(
                                          CupertinoIcons.chevron_down,
                                          size: 25,
                                        ),
                                        hintText: '${localize.selectAccount}*',
                                        textStyle: textStyle(
                                          context,
                                          style: StyleType.bodMed,
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
                                                  style: StyleType.bodMed,
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
                                      context
                                          .push(MyRoute.addAccountScreen)
                                          .whenComplete(
                                        () {
                                          if (context.mounted) {
                                            context.read<AccountBloc>().add(
                                                  GetAccountsEvent(),
                                                );
                                          }
                                        },
                                      );
                                    },
                                    child: const AppGlass(
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              );
                            },
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
                                imageBytes: picture,
                              );
                            },
                          ),
                          Gap.vertical(16),
                          AppButton.outlined(
                            label: localize.delete,
                            onPressed: () async {
                              final id = transaction?.id;
                              final title = localize.deleteTransaction;
                              final contentText =
                                  localize.confirmDeleteTransaction;
                              final result =
                                  await AppDialog.showConfirmationDelete(
                                context,
                                title,
                                contentText,
                              );
                              if (result != null && id != null) {
                                _onDeleteTransaction(
                                  budget!,
                                  id: id,
                                  amount: transaction!.amount,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: BottomSheetParent(
                          isWithBorderTop: true,
                          child: BlocConsumer<TransactionsCubit,
                              TransactionsState>(
                            listener: (context, state) {
                              if (state
                                  is UpdateItemCategoryTransactionSuccess) {
                                context.pop();

                                context
                                    .read<CategoryCubit>()
                                    .getItemCategoryTransactions(
                                      itemId: itemId!,
                                    );

                                context.read<BudgetBloc>().add(
                                      GetBudgetsByIdEvent(
                                        id: budget!.id,
                                      ),
                                    );
                                _reset();
                                context.pop();
                              }

                              if (state is UpdateBudgetSuccess) {
                                _reset();
                                context.pop();
                              }

                              if (state
                                  is UpdateItemCategoryTransactionFailed) {
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
                                label: localize.update,
                                isActive: true,
                                onPressed: () {
                                  final id = transaction?.id;
                                  final itemId = transaction?.itemHistoId;
                                  final amount =
                                      ControllerHelper.getAmount(context);
                                  // final date = ControllerHelper.getSingleDateString(context);
                                  final createdAt = transaction?.createdAt;
                                  final type = transaction?.type;
                                  final budgetId = transaction?.budgetId;
                                  final groupId = transaction?.groupId;
                                  final imageBytes =
                                      ControllerHelper.getImagesBytes(context);
                                  final prevsAccountId = transaction?.accountId;
                                  final prevsAccount = stateCategory.account;

                                  if (itemId != null &&
                                      id != null &&
                                      amount != null &&
                                      type != null &&
                                      budgetId != null &&
                                      groupId != null &&
                                      prevsAccountId != null &&
                                      createdAt != null &&
                                      _selectedAccount != null &&
                                      _spendOnController.text.isNotEmpty) {
                                    final selectedAccountId =
                                        _selectedAccount?.id ?? prevsAccountId;

                                    final newTransaction =
                                        ItemCategoryTransaction(
                                      id: id,
                                      itemHistoId: itemId,
                                      categoryName: categoryName!,
                                      amount: amount,
                                      createdAt: createdAt,
                                      type: transaction!.type,
                                      spendOn: _spendOnController.text,
                                      budgetId: budgetId,
                                      picture: imageBytes,
                                      groupId: groupId,
                                      updatedAt: DateTime.now().toString(),
                                      accountId: selectedAccountId,
                                    );

                                    if (prevsAccount?.id !=
                                        _selectedAccount?.id) {
                                      final trxAmount = transaction.amount;
                                      context.read<AccountBloc>().add(
                                            UpdateAccountEvent(
                                              prevsAccount!.copyWith(
                                                amount: prevsAccount.amount +
                                                    trxAmount,
                                              ),
                                            ),
                                          );
                                      context
                                          .read<TransactionsCubit>()
                                          .updateItemCategoryTransaction(
                                            newTransaction,
                                            amount: amount,
                                            selectedAccount: _selectedAccount,
                                          );
                                    } else {
                                      final trxAmount = transaction.amount;
                                      if (trxAmount != amount) {
                                        final diff = trxAmount - amount;

                                        final updatedAccount =
                                            prevsAccount!.copyWith(
                                          amount: prevsAccount.amount + diff,
                                        );

                                        context.read<AccountBloc>().add(
                                              UpdateAccountEvent(
                                                  updatedAccount),
                                            );
                                      }

                                      context
                                          .read<TransactionsCubit>()
                                          .updateItemCategoryTransaction(
                                            newTransaction,
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
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onDeleteTransaction(
    Budget budget, {
    required String id,
    required double amount,
  }) {
    context.read<CategoryCubit>().deleteItemCategoryTransaction(
          id: id,
        );

    context.pop();
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
}
