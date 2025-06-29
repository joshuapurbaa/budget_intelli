import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFormField extends StatefulWidget {
  const AppFormField({
    required this.onChanged,
    required this.controller,
    required this.hintText,
    super.key,
    this.keyboardType,
    this.initialValue,
    this.hintStyle,
    this.autofocus = false,
    this.focusNode,
  });

  final void Function(String) onChanged;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final int? initialValue;
  final TextStyle? hintStyle;
  final bool autofocus;
  final FocusNode? focusNode;
  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        hintStyle: widget.hintStyle ??
            textStyle(
              context,
              style: StyleType.bodMed,
            ).copyWith(
              color: context.color.onSurface.withValues(alpha: 0.5),
            ),
        hintText: widget.hintText,
      ),
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType ?? TextInputType.text,
    );
  }
}
