import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class SummaryDashboardItem extends StatelessWidget {
  const SummaryDashboardItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getEdgeInsets(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: context.color.onInverseSurface,
            child: getPngAsset(
              cloth,
            ),
          ),
          Gap.horizontal(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Clothing',
                  style: StyleType.headSm,
                ),
                Gap.vertical(5),
                AppText(
                  text: 'Cash',
                  style: StyleType.bodMd,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                text: '\$',
                style: StyleType.bodMd,
              ),
              AppText(
                text: '0.0',
                style: StyleType.headLg,
              ),
            ],
          )
        ],
      ),
    );
  }
}
