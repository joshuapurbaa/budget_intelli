import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Explores extends StatefulWidget {
  const Explores({
    required this.user,
    super.key,
  });

  final UserIntelli? user;

  @override
  State<Explores> createState() => _ExploresState();
}

class _ExploresState extends State<Explores> {
  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: getEdgeInsetsAll(16),
          sliver: SliverFillRemaining(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap.vertical(50),
                AppText(
                  text: localize.explore,
                  style: StyleType.headLg,
                ),
                Gap.vertical(20),
                Expanded(
                  child: GridView.count(
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      // AppGlass(
                      //   onTap: () {
                      //     context.push(
                      //       RouteName.chatScreen,
                      //     );
                      //   },
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       getSvgPicture(
                      //         chatBot,
                      //         width: 50,
                      //         height: 50,
                      //         color: Theme.of(context).colorScheme.onSurface,
                      //       ),
                      //       Gap.vertical(22),
                      //       AppText(
                      //         text: localize.chatWithAi,
                      //         style: StyleType.h6def18,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      AppGlass(
                        onTap: () {
                          context.push(
                            MyRoute.netWorthTracker,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getPngAsset(
                              netWorthPng,
                              width: 50,
                              height: 50,
                              color: context.color.onSurface,
                            ),
                            Gap.vertical(22),
                            AppText(
                              text: localize.netWorthTracker,
                              style: StyleType.bodLg,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      AppGlass(
                        onTap: () {
                          context.read<AccountBloc>().add(GetAccountsEvent());
                          context.push(
                            MyRoute.accountScreen,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getPngAsset(
                              accountPng,
                              width: 50,
                              height: 50,
                              color: context.color.onSurface,
                            ),
                            Gap.vertical(22),
                            AppText(
                              text: localize.accountBalance,
                              style: StyleType.bodLg,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      AppGlass(
                        onTap: () {
                          context.push(
                            MyRoute.financialCalculator,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getPngAsset(
                              financialCalculatorPng,
                              width: 50,
                              height: 50,
                              color: context.color.onSurface,
                            ),
                            Gap.vertical(22),
                            AppText(
                              text: localize.financialCalculator,
                              style: StyleType.bodLg,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      AppGlass(
                        onTap: () {
                          context.read<SchedulePaymentDbBloc>().add(
                                GetSchedulePaymentsFromDb(),
                              );
                          context.pushNamed(
                            MyRoute.schedulePaymentsList.noSlashes(),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getPngAsset(
                              schedulePayment,
                              width: 50,
                              height: 50,
                              color: context.color.onSurface,
                            ),
                            Gap.vertical(22),
                            AppText(
                              text: localize.schedulePayment,
                              style: StyleType.bodLg,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      AppGlass(
                        onTap: () {
                          context.read<GoalDatabaseBloc>().add(
                                GetGoalsFromDbEvent(),
                              );
                          context.pushNamed(
                            MyRoute.goalList.noSlashes(),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getPngAsset(
                              goalsPng,
                              width: 50,
                              height: 50,
                              color: context.color.onSurface,
                            ),
                            Gap.vertical(22),
                            const AppText(
                              text: 'Goals',
                              style: StyleType.bodLg,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      AppGlass(
                        onTap: () {
                          context.read<MyPortfolioDbBloc>().add(
                                const GetMyPortfolioListDbEvent(),
                              );
                          context.pushNamed(
                            MyRoute.myPortfolio.noSlashes(),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getPngAsset(
                              portfolioPng,
                              width: 50,
                              height: 50,
                              color: context.color.onSurface,
                            ),
                            Gap.vertical(22),
                            const AppText(
                              text: 'My Portfolio',
                              style: StyleType.bodLg,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      // AppGlass(
                      //   onTap: () {
                      //     context.push(
                      //       RouteName.accountScreen,
                      //     );
                      //   },
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       getPngAsset(
                      //         accountPng,
                      //         width: 50,
                      //         height: 50,
                      //         color: context.color.onSurface,
                      //       ),
                      //       Gap.vertical(22),
                      //       AppText(
                      //         text: localize.accountBalance,
                      //         style: StyleType.bodLg,
                      //         textAlign: TextAlign.center,
                      //         maxLines: 2,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
