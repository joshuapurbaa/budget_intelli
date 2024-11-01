import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class AppSliverBody extends StatelessWidget {
  const AppSliverBody({
    required this.appBarTitle,
    required this.sliver,
    super.key,
  });

  final String appBarTitle;
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBarPrimary(
          title: appBarTitle,
        ),
        SliverPadding(
          padding: getEdgeInsetsAll(16),
          sliver: sliver,
        ),
      ],
    );
  }
}
