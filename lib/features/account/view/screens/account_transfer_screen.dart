import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AccountTransferScreen extends StatefulWidget {
  const AccountTransferScreen({super.key});

  @override
  State<AccountTransferScreen> createState() => _AccountTransferScreenState();
}

class _AccountTransferScreenState extends State<AccountTransferScreen> {
  Account? _firstSelectedAccount;
  Account? _secondSelectedAccount;

  void _onTransferSuccess(AccountState state) {
    final premium = ControllerHelper.getPremium(context);
    if (premium) {
      _insertToFirestore(state);
      _transferSuccess();
    } else {
      _transferSuccess();
    }
  }

  Future<void> _insertToFirestore(AccountState state) async {
    if (state.updatedFirstAccountParam != null &&
        state.updatedSecondAccountParam != null) {
      await context.read<BudgetFirestoreCubit>().transferAccountFirestore(
            updatedFirstAccount: state.updatedFirstAccountParam!,
            updatedSecondAccount: state.updatedSecondAccountParam!,
          );
    } else {
      AppToast.showToastError(
        context,
        textLocalizer(context).anErrorOccured,
      );
    }
  }

  void _transferSuccess() {
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
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          _reset();
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBarPrimary(
              title: localize.accountTransfer,
            ),
            BlocConsumer<AccountBloc, AccountState>(
              listener: (context, state) {
                final transferSuccess = state.transferSuccess;

                if (transferSuccess) {
                  _onTransferSuccess(state);
                }
              },
              builder: (context, state) {
                final accounts = state.accounts;

                return SliverPadding(
                  padding: getEdgeInsetsAll(16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Gap.vertical(16),
                        AppGlass(
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
                            inputDecorationTheme: _inputDecoration(context),
                            trailingIcon: const Icon(
                              CupertinoIcons.chevron_down,
                              size: 25,
                            ),
                            hintText: '${localize.account} 1',
                            textStyle: textStyle(
                              context,
                              style: StyleType.bodMed,
                            ).copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            requestFocusOnTap: false,
                            onSelected: (Account? account) {
                              setState(() {
                                _firstSelectedAccount = account;
                              });
                            },
                            menuStyle: _menuStyle(),
                            dropdownMenuEntries:
                                accounts.map<DropdownMenuEntry<Account>>(
                              (Account account) {
                                return DropdownMenuEntry<Account>(
                                  value: account,
                                  label: account.name,
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
                        Gap.vertical(16),
                        BoxCalculator(
                          label: '${localize.amountFieldLabel}*',
                        ),
                        Gap.vertical(16),
                        Icon(
                          CupertinoIcons.arrow_down,
                          color: context.color.onSurface.withValues(alpha: 0.5),
                        ),
                        Gap.vertical(16),
                        AppGlass(
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
                            inputDecorationTheme: _inputDecoration(context),
                            trailingIcon: const Icon(
                              CupertinoIcons.chevron_down,
                              size: 25,
                            ),
                            hintText: '${localize.account} 2',
                            textStyle: textStyle(
                              context,
                              style: StyleType.bodMed,
                            ).copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            requestFocusOnTap: false,
                            onSelected: (Account? account) {
                              setState(() {
                                _secondSelectedAccount = account;
                              });
                            },
                            menuStyle: _menuStyle(),
                            dropdownMenuEntries:
                                accounts.map<DropdownMenuEntry<Account>>(
                              (Account account) {
                                return DropdownMenuEntry<Account>(
                                  value: account,
                                  label: account.name,
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
                        Gap.vertical(16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        bottomSheet: BottomSheetParent(
          isWithBorderTop: true,
          child: AppButton.darkLabel(
            label: localize.save,
            isActive: true,
            onPressed: () {
              final amount = ControllerHelper.getAmount(context);

              if (_firstSelectedAccount == _secondSelectedAccount) {
                AppToast.showToastError(
                  context,
                  localize.selectDifferentAccount,
                );
                return;
              }

              if (amount != null &&
                  _firstSelectedAccount != null &&
                  _secondSelectedAccount != null) {
                final firstAmount = _firstSelectedAccount?.amount;
                final secondAmount = _secondSelectedAccount?.amount;

                if (firstAmount != null && secondAmount != null) {
                  final updatedFirstAmount = firstAmount - amount;
                  final updatedSecondAmount = secondAmount + amount;

                  final updatedFirstAccount = _firstSelectedAccount!.copyWith(
                    amount: updatedFirstAmount,
                  );

                  final updatedSecondAccount = _secondSelectedAccount!.copyWith(
                    amount: updatedSecondAmount,
                  );

                  context.read<AccountBloc>().add(
                        TransferAccountEvent(
                          updatedFirstAccount: updatedFirstAccount,
                          updatedSecondAccount: updatedSecondAccount,
                        ),
                      );
                }
              } else {
                AppToast.showToastError(
                  context,
                  localize.pleaseFillAllRequiredFields,
                );
                return;
              }
            },
          ),
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
    context.read<BoxCalculatorCubit>().unselect();
    context.read<AccountBloc>().add(SetAccountBlocToInitial());
    context.read<AccountBloc>().add(GetAccountsEvent());
    context.read<BudgetFirestoreCubit>().resetState();
  }
}
