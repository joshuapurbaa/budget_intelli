import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

AppBar appBarPrimary({
  required BuildContext context,
  Widget? leading,
  List<Widget>? action,
  String? title,
  bool? centerTitle,
  Color? backgroundColor,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: backgroundColor ?? context.color.surface,
    iconTheme: IconThemeData(
      color: context.color.onSurface,
    ),
    leading: leading ??
        GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: getPngAsset(
              arrowLeftWhite,
              color: context.color.onSurface,
            ),
          ),
        ),
    title: AppText(
      text: title ?? '',
      style: StyleType.headLg,
      color: context.color.onSurface,
    ),
    centerTitle: centerTitle ?? true,
    actions: action,
  );
}
