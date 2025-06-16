import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/net_worth_barrel.dart';
import 'package:budget_intelli/features/net_worth/view/widgets/net_worth_line_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NetWorthTrackerScreen extends StatefulWidget {
  const NetWorthTrackerScreen({super.key});

  @override
  State<NetWorthTrackerScreen> createState() => _NetWorthTrackerScreenState();
}

class _NetWorthTrackerScreenState extends State<NetWorthTrackerScreen> {
  List<bool> expandListTileValue = [false, false];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    context.read<NetWorthBloc>().add(GetAssetList());
    context.read<NetWorthBloc>().add(GetLiabilityList());
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final paddingLRB = getEdgeInsets(left: 16, right: 16, bottom: 10);
    return BlocConsumer<NetWorthBloc, NetWorthState>(
      listenWhen: (previous, current) {
        final result = previous.assets != current.assets ||
            previous.liabilities != current.liabilities;

        return result;
      },
      listener: (context, state) {
        _getData();
      },
      builder: (context, state) {
        final assetList = state.assets;
        final liabilityList = state.liabilities;
        var totalAsset = 0.0;
        var totalLiability = 0.0;
        var totalNetWorth = 0.0;

        for (var i = 0; i < assetList.length; i++) {
          totalAsset += assetList[i].amount;
        }

        for (var i = 0; i < liabilityList.length; i++) {
          totalLiability += liabilityList[i].amount;
        }

        totalNetWorth = totalAsset - totalLiability;
        final color = totalNetWorth >= 0 ? Colors.green : Colors.red;

        final appDivider = AppDivider(
          color: context.color.onSurface.withValues(
            alpha: 0.1,
          ),
          thickness: 0.4,
        );

        return RefreshIndicator.adaptive(
          onRefresh: () async {
            _getData();
          },
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBarPrimary(
                  title: localize.netWorthTracker,
                ),
                SliverFillRemaining(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Gap.vertical(10),

                      // Total Net Worth
                      AppGlass(
                        margin: paddingLRB,
                        child: Column(
                          children: [
                            AppText(
                              text: localize.netWorth,
                              style: StyleType.bodMed,
                              fontWeight: FontWeight.bold,
                            ),
                            AppText(
                              text: NumberFormatter.formatToMoneyDouble(
                                context,
                                totalNetWorth,
                              ),
                              style: StyleType.bodMed,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ],
                        ),
                      ),

                      // Total Asset
                      AppGlass(
                        margin: paddingLRB,
                        child: Column(
                          children: [
                            ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              expansionAnimationStyle: const AnimationStyle(
                                duration: Duration(
                                  milliseconds: 100,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              childrenPadding: getEdgeInsets(
                                left: 5,
                                right: 5,
                              ),
                              title: AppText(
                                text: localize.totalAsset,
                                style: StyleType.bodMed,
                                fontWeight: FontWeight.bold,
                              ),
                              leading: Icon(
                                expandListTileValue[0]
                                    ? CupertinoIcons.chevron_up
                                    : CupertinoIcons.chevron_down,
                              ),
                              trailing: AppText(
                                text: NumberFormatter.formatToMoneyDouble(
                                  context,
                                  totalAsset,
                                ),
                                style: StyleType.bodMed,
                                fontWeight: FontWeight.bold,
                              ),
                              onExpansionChanged: (value) {
                                setState(() {
                                  expandListTileValue[0] = value;
                                });
                              },
                              children: List.generate(
                                assetList.length,
                                (index) {
                                  final category = assetList[index].name;
                                  final amount = assetList[index].amount;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Column(
                                      children: [
                                        appDivider,
                                        Gap.vertical(15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: AppText(
                                                text: category,
                                                style: StyleType.bodMed,
                                                color: context.color.primary,
                                              ),
                                            ),
                                            AppText(
                                              text: NumberFormatter
                                                  .formatToMoneyDouble(
                                                context,
                                                amount,
                                              ),
                                              style: StyleType.bodMed,
                                              color: context.color.primary,
                                            ),
                                            Gap.horizontal(10),
                                            GestureDetector(
                                              onTap: () {
                                                context.push(
                                                  MyRoute.addAssetAccount,
                                                  extra: assetList[index],
                                                );
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: context.color.primary,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Gap.vertical(10),
                            appDivider,
                            Gap.vertical(10),
                            // Add Asset Button
                            GestureDetector(
                              onTap: () {
                                context.push(MyRoute.addAssetAccount);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.add,
                                    color: context.color.primary,
                                    size: 20,
                                  ),
                                  Gap.horizontal(10),
                                  AppText(
                                    text: localize.addAsset,
                                    style: StyleType.bodMed,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Total Liability
                      AppGlass(
                        margin: paddingLRB,
                        child: Column(
                          children: [
                            ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              expansionAnimationStyle: const AnimationStyle(
                                duration: Duration(
                                  milliseconds: 100,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              childrenPadding: getEdgeInsets(
                                left: 5,
                                right: 5,
                              ),
                              title: AppText(
                                text: localize.totalLiability,
                                style: StyleType.bodMed,
                                fontWeight: FontWeight.bold,
                              ),
                              leading: Icon(
                                expandListTileValue[1]
                                    ? CupertinoIcons.chevron_up
                                    : CupertinoIcons.chevron_down,
                              ),
                              trailing: AppText(
                                text: NumberFormatter.formatToMoneyDouble(
                                  context,
                                  totalLiability,
                                ),
                                style: StyleType.bodMed,
                                fontWeight: FontWeight.bold,
                              ),
                              onExpansionChanged: (value) {
                                setState(() {
                                  expandListTileValue[1] = value;
                                });
                              },
                              children: List.generate(
                                liabilityList.length,
                                (index) {
                                  final category = liabilityList[index].name;
                                  final amount = liabilityList[index].amount;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Column(
                                      children: [
                                        Gap.vertical(5),
                                        appDivider,
                                        Gap.vertical(5),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: AppText(
                                                text: category,
                                                style: StyleType.bodMed,
                                                color: context.color.primary,
                                              ),
                                            ),
                                            AppText(
                                              text: NumberFormatter
                                                  .formatToMoneyDouble(
                                                context,
                                                amount,
                                              ),
                                              style: StyleType.bodMed,
                                              color: context.color.primary,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Gap.vertical(10),
                            appDivider,
                            Gap.vertical(10),

                            // Add Liability Button
                            GestureDetector(
                              onTap: () {
                                context.push(MyRoute.addLiabilityAccount);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.add,
                                    color: context.color.primary,
                                    size: 20,
                                  ),
                                  Gap.horizontal(10),
                                  AppText(
                                    text: localize.addLiability,
                                    style: StyleType.bodMed,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (assetList.isNotEmpty && liabilityList.isNotEmpty)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Container(
                            margin: paddingLRB,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: getEdgeInsets(top: 25),
                            child: NetWorthLineChart(
                              assetList: assetList,
                              liabilityList: liabilityList,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
