import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class SliverAppBarPrimary extends StatelessWidget {
  const SliverAppBarPrimary({
    required this.title,
    this.leading,
    this.action,
    super.key,
    this.centerTitle,
    this.backgroundColor,
    this.titleTextStyle,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? action;
  final bool? centerTitle;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: backgroundColor,
      titleTextStyle: titleTextStyle,
      pinned: true,
      title: AppText(
        text: title,
        style: StyleType.headMed,
      ),
      centerTitle: centerTitle ?? true,
      floating: true,
      snap: true,
      leading: leading,
      actions: action,
    );
  }
}
