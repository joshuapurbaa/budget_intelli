import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _accountNameController = TextEditingController();
  final _accountTypeController = TextEditingController();
  String? _selectedAccountType;
  Account? _selectedAccount;
  final _focusNodeAccountName = FocusNode();

  @override
  void initState() {
    super.initState();
    _reset();
    context.read<AccountBloc>().add(SetInitialAccountTypes());
    _setInitialData();
  }

  void _setInitialData() {
    final state = context.read<AccountBloc>().state;
    final selectedAccount = state.selectedAccount;

    if (selectedAccount != null) {
      context.read<BoxCalculatorCubit>().select(
            selectedAccount.amount.toString(),
            onUpdateFromState: true,
          );
      _accountNameController.text = selectedAccount.name;
      _accountTypeController.text = selectedAccount.accountType;

      setState(() {
        _selectedAccount = selectedAccount;
        _selectedAccountType = selectedAccount.accountType;
      });
    } else {
      context.read<BoxCalculatorCubit>().unselect();
      _accountNameController.clear();
      _accountTypeController.clear();
      setState(() {
        _selectedAccount = null;
        _selectedAccountType = null;
      });
    }
  }

  void _onInsertSuccess(Account? account) {
    final localize = textLocalizer(context);
    if (account != null) {
      final premium = ControllerHelper.getPremium(context);
      if (premium) {
        _insertToFirestore(account);
        _insertSuccess();
      } else {
        _insertSuccess();
      }
    } else {
      AppToast.showToastError(
        context,
        localize.anErrorOccured,
      );
    }
  }

  Future<void> _insertToFirestore(Account account) async {
    await context
        .read<BudgetFirestoreCubit>()
        .insertAccountToFirestore(account: account);
  }

  Future<void> _updateFirestore(Account account) async {
    await context
        .read<BudgetFirestoreCubit>()
        .updateAccountToFirestore(account: account);
  }

  void _insertSuccess() {
    final localize = textLocalizer(context);
    AppToast.showToastSuccess(
      context,
      localize.createdSuccessFully,
    );
    context.pop();
    _reset();
  }

  void _onUpdateSuccess(Account? account) {
    final localize = textLocalizer(context);
    if (account != null) {
      final premium = ControllerHelper.getPremium(context);
      if (premium) {
        _updateFirestore(account);
        _updateSuccess();
      } else {
        _updateSuccess();
      }
    } else {
      AppToast.showToastError(
        context,
        localize.anErrorOccured,
      );
    }
  }

  void _updateSuccess() {
    final localize = textLocalizer(context);
    AppToast.showToastSuccess(
      context,
      localize.updatedSuccessFully,
    );
    context.pop();
    _reset();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final paddingLTR = getEdgeInsets(
      left: 16,
      right: 16,
      top: 16,
    );
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          _reset();
        }
      },
      child: Scaffold(
        body: BlocConsumer<AccountBloc, AccountState>(
          listener: (context, state) {
            final insertSuccess = state.insertSuccess;
            final updateSuccess = state.updateSuccess;

            if (updateSuccess) {
              _onUpdateSuccess(state.newAccountParam);
            }

            if (insertSuccess) {
              _onInsertSuccess(state.newAccountParam);
            }

            if (state.error != null) {
              AppToast.showToastError(
                context,
                state.error ?? localize.anErrorOccured,
              );
            }
          },
          builder: (context, state) {
            final accountTypes = state.accountTypes;
            final isEdit = _selectedAccount != null;

            String? title;
            if (isEdit) {
              title = '${localize.edit} ${localize.accountBalance}';
            } else {
              title = '${localize.add} ${localize.accountBalance}';
            }

            return CustomScrollView(
              slivers: [
                SliverAppBarPrimary(
                  title: title,
                ),
                SliverPadding(
                  padding: paddingLTR,
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        AppBoxFormField(
                          hintText: localize.accountName,
                          prefixIcon: noteDescriptionPng,
                          controller: _accountNameController,
                          focusNode: _focusNodeAccountName,
                          isPng: true,
                          iconColor: context.color.onSurface,
                        ),
                        Gap.vertical(8),
                        AppGlass(
                          padding: getEdgeInsets(
                            left: 16,
                            right: 10,
                          ),
                          child: DropdownMenu<String>(
                            controller: _accountTypeController,
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
                            inputDecorationTheme: _inputDecoration(context),
                            trailingIcon: const Icon(
                              CupertinoIcons.chevron_down,
                              size: 25,
                            ),
                            hintText: '${localize.selectCategory}*',
                            textStyle: textStyle(
                              context,
                              style: StyleType.bodMed,
                            ).copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            requestFocusOnTap: false,
                            onSelected: (String? accountType) {
                              setState(() {
                                _selectedAccountType = accountType;
                              });
                            },
                            menuStyle: _menuStyle(),
                            dropdownMenuEntries:
                                accountTypes.map<DropdownMenuEntry<String>>(
                              (String accountType) {
                                return DropdownMenuEntry<String>(
                                  value: accountType,
                                  label: accountType,
                                  style: MenuItemButton.styleFrom(
                                    visualDensity: VisualDensity.comfortable,
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
                        Gap.vertical(8),
                        BoxCalculator(
                          label: '${localize.amountFieldLabel}*',
                        ),
                        Gap.vertical(16),
                        BlocBuilder<BudgetFirestoreCubit, BudgetFirestoreState>(
                          builder: (context, state) {
                            final loading = state.loadingFirestore;
                            return loading
                                ? const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  )
                                : AppButton(
                                    label: _selectedAccount != null
                                        ? localize.update
                                        : localize.add,
                                    onPressed: () {
                                      final amount =
                                          ControllerHelper.getAmount(context);

                                      if (amount != null &&
                                          _accountNameController
                                              .text.isNotEmpty &&
                                          _selectedAccountType != null) {
                                        final acc = _selectedAccount;
                                        if (acc != null) {
                                          final updatedAccount = Account(
                                            id: acc.id,
                                            name: _accountNameController.text,
                                            accountType: _selectedAccountType!,
                                            amount: amount,
                                            createdAt: acc.createdAt,
                                            updatedAt:
                                                DateTime.now().toString(),
                                          );

                                          context.read<AccountBloc>().add(
                                                UpdateAccountEvent(
                                                  updatedAccount,
                                                ),
                                              );
                                        } else {
                                          final newAccount = Account(
                                            id: const Uuid().v1(),
                                            name: _accountNameController.text,
                                            accountType: _selectedAccountType!,
                                            amount: amount,
                                            createdAt:
                                                DateTime.now().toString(),
                                            updatedAt:
                                                DateTime.now().toString(),
                                          );

                                          context.read<AccountBloc>().add(
                                                InsertAccountEvent(newAccount),
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
                        if (isEdit) ...[
                          Gap.vertical(8),
                          BlocListener<AccountBloc, AccountState>(
                            listener: (context, state) {
                              final deleteSuccess = state.deleteSuccess;
                              if (deleteSuccess) {
                                AppToast.showToastSuccess(
                                  context,
                                  localize.successfullyDeleted,
                                );
                                context.pop();
                                _reset();
                              }
                            },
                            child: AppButton.outlined(
                              label: localize.delete,
                              onPressed: () async {
                                final result =
                                    await AppDialog.showConfirmationDelete(
                                  context,
                                  localize.delete,
                                  localize.confirmDelete,
                                );

                                if (result != null) {
                                  final acc = _selectedAccount;
                                  if (acc != null) {
                                    if (context.mounted) {
                                      context.read<AccountBloc>().add(
                                            DeleteAccountEvent(acc.id),
                                          );
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
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
        style: StyleType.bodMed,
      ).copyWith(
        fontWeight: FontWeight.w400,
        color: context.color.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  void _reset() {
    _accountNameController.clear();
    _focusNodeAccountName.unfocus();
    context.read<BoxCalculatorCubit>().unselect();
    context.read<AccountBloc>()
      ..add(SetAccountBlocToInitial())
      ..add(GetAccountsEvent());
    context.read<BudgetFirestoreCubit>().resetState();
  }
}
