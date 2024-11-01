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
  });

  final void Function(String) onChanged;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final int? initialValue;
  final TextStyle? hintStyle;

  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        controller: widget.controller,
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
                StyleType.bodMd,
              ),
          hintText: widget.hintText,
        ),
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType ?? TextInputType.text,
      ),
    );
  }
}
