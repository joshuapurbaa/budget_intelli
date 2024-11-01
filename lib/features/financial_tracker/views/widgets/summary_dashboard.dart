import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class SummaryDashboard extends StatelessWidget {
  const SummaryDashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final widthSummaryContainer = width / 3;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: getEdgeInsetsAll(20),
            decoration: BoxDecoration(
              color: context.color.onInverseSurface,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                const AppText(
                  text: 'Day',
                  style: StyleType.headSm,
                ),
                Gap.vertical(10),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    AppText(
                      text: r'$',
                      style: StyleType.bodMd,
                    ),
                    AppText(
                      text: '0.0',
                      style: StyleType.headLg,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Gap.horizontal(5),
        Expanded(
          child: Container(
            padding: getEdgeInsetsAll(20),
            decoration: BoxDecoration(
              color: context.color.onInverseSurface,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                const AppText(
                  text: 'Week',
                  style: StyleType.headSm,
                ),
                Gap.vertical(10),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    AppText(
                      text: r'$',
                      style: StyleType.bodMd,
                    ),
                    AppText(
                      text: '0.0',
                      style: StyleType.headLg,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Gap.horizontal(5),
        Expanded(
          child: Container(
            padding: getEdgeInsetsAll(20),
            decoration: BoxDecoration(
              color: context.color.onInverseSurface,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                const AppText(
                  text: 'Month',
                  style: StyleType.headSm,
                ),
                Gap.vertical(10),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    AppText(
                      text: r'$',
                      style: StyleType.bodMd,
                    ),
                    AppText(
                      text: '0.0',
                      style: StyleType.headLg,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
