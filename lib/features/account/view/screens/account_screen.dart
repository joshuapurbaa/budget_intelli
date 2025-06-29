import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/view/controller/controller.dart';
import 'package:budget_intelli/features/settings/controller/settings_bloc/settings_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void _whenCompleteAccountTransactionScreen() {
    context.read<AccountBloc>()
      ..add(
        GetAccountsEvent(),
      )
      ..add(SelectAccountEvent(null));
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final showAmount = context.read<SettingBloc>().state.showAmount;

    return Scaffold(
      appBar: appBarPrimary(
        context: context,
        title: localize.accountBalance,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          var totalAmount = 0.0;
          final accounts = state.accounts;

          if (accounts.isNotEmpty) {
            totalAmount = accounts
                .map((e) => e.amount)
                .reduce((value, element) => value + element);
          }

          if (accounts.isEmpty) {
            return AppGlass(
              onTap: () {
                context.push(MyRoute.addAccountScreen);
              },
              margin: getEdgeInsetsAll(16),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.add,
                  ),
                  Gap.horizontal(16),
                  AppText(
                    text: '${localize.add} ${localize.accountBalance}',
                    style: StyleType.bodMed,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AppGlass(
                  margin: getEdgeInsets(
                    left: 16,
                    right: 16,
                    top: 10,
                    bottom: 10,
                  ),
                  child: showAmount
                      ? RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Total: ',
                                style: textStyle(
                                  context,
                                  style: StyleType.bodLg,
                                ).copyWith(
                                  color: context.color.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              TextSpan(
                                text: NumberFormatter.formatToMoneyDouble(
                                  context,
                                  totalAmount,
                                ),
                                style: textStyle(
                                  context,
                                  style: StyleType.bodLg,
                                ).copyWith(
                                  color: context.color.primary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: 'Total: ',
                              style: StyleType.bodLg,
                              color: context.color.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                            Icon(
                              FontAwesomeIcons.ellipsis,
                              color: context.color.primary,
                              size: 22,
                            ),
                          ],
                        ),
                ),
              ),
              SliverFillRemaining(
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: getEdgeInsetsAll(12),
                        itemCount: accounts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          final account = accounts[index];

                          return AppGlass(
                            onTap: () {
                              context.read<AccountBloc>().add(
                                    SelectAccountEvent(
                                      account,
                                    ),
                                  );

                              context
                                  .push(MyRoute.accountTransactionScreen)
                                  .whenComplete(
                                    _whenCompleteAccountTransactionScreen,
                                  );
                            },
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.read<AccountBloc>().add(
                                          SelectAccountEvent(
                                            account,
                                          ),
                                        );

                                    context
                                        .push(MyRoute.addAccountScreen)
                                        .whenComplete(
                                          _whenCompleteAccountTransactionScreen,
                                        );
                                  },
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: context.color.secondary,
                                    ),
                                  ),
                                ),
                                Align(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppText(
                                        text: account.name,
                                        style: StyleType.bodLg,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        color: context.color.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      Gap.vertical(16),
                                      AppDivider(
                                        color: context.color.onSurface
                                            .withValues(alpha: 0.1),
                                      ),
                                      Gap.vertical(16),
                                      if (showAmount)
                                        AppText(
                                          text: NumberFormatter
                                              .formatToMoneyDouble(
                                            context,
                                            account.amount,
                                          ),
                                          style: StyleType.bodMed,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          fontWeight: FontWeight.w500,
                                        )
                                      else
                                        Icon(
                                          FontAwesomeIcons.ellipsis,
                                          color: context.color.primary,
                                          size: 22,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    BottomSheetParent(
                      isWithBorderTop: true,
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppButton.darkLabel(
                              label: localize.add,
                              isActive: true,
                              onPressed: () {
                                context
                                    .read<AccountBloc>()
                                    .add(SelectAccountEvent(null));
                                context.push(MyRoute.addAccountScreen);
                              },
                            ),
                            Gap.vertical(10),
                            AppButton.outlined(
                              label: localize.accountTransfer,
                              onPressed: () {
                                context.push(MyRoute.accountTransferScreen);
                              },
                            ),
                          ],
                        ),
                      ),
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
}
