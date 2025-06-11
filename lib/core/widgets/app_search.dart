import 'package:budget_intelli/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSearch extends StatelessWidget {
  const AppSearch({
    required this.onChanged,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.suffixIcon,
    super.key,
  });

  final void Function(String) onChanged;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return AppGlass(
      padding: EdgeInsets.zero,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            CupertinoIcons.search,
            size: 20,
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          hintStyle: textStyle(
            context,
            StyleType.bodSm,
          ).copyWith(
            color: context.color.onSurface.withValues(alpha: 0.5),
          ),
          hintText: hintText,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
