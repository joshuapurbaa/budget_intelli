import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class InsightPart extends StatelessWidget {
  const InsightPart({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final paddingLRB = getEdgeInsets(
      left: 16,
      right: 16,
      bottom: 10,
    );
    return SliverToBoxAdapter(
      child: AppGlass(
        margin: paddingLRB,
        height: 300,
        child: Column(
          children: [
            AppText(
              text: title,
              style: StyleType.bodMed,
              fontWeight: FontWeight.bold,
            ),
            Gap.vertical(16),
            ...children,
          ],
        ),
      ),
    );
  }
}
