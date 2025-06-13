import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBoxFormField extends StatelessWidget {
  const AppBoxFormField({
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.focusNode,
    required this.isPng,
    super.key,
    this.keyboardType,
    this.iconColor,
    this.onFieldSubmitted,
    this.padding,
    this.onTap,
    this.onChanged,
    this.labelColor,
    this.margin,
    this.suffixIcon,
  });

  final String hintText;
  final String prefixIcon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Color? iconColor;
  final FocusNode focusNode;
  final void Function(String)? onFieldSubmitted;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isPng;
  final void Function(String)? onChanged;
  final Color? labelColor;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return AppGlass(
      padding: padding,
      margin: margin,
      height: 70.h,
      child: Row(
        children: [
          if (isPng)
            getPngAsset(
              prefixIcon,
              // height: 20,
              // width: 20,
              color: iconColor,
            )
          else
            getRivAsset(
              prefixIcon,
              // height: 20,
              // width: 20,
            ),
          Gap.horizontal(16),
          Expanded(
            child: TextFormField(
              // readOnly: onTap != null,
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              focusNode: focusNode,
              keyboardType: keyboardType ?? TextInputType.text,
              controller: controller,
              inputFormatters: keyboardType == TextInputType.number
                  ? [ThousandsFormatter()]
                  : null,
              style: textStyle(
                context,
                style: StyleType.bodMed,
              ).copyWith(
                color: labelColor,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: textStyle(
                  context,
                  style: StyleType.bodMed,
                ).copyWith(
                  fontWeight: FontWeight.w400,
                  color: context.color.onSurface.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                // contentPadding: EdgeInsets.symmetric(
                //   vertical: 12.h,
                // ),
              ),
              onFieldSubmitted: onFieldSubmitted,
              onTap: onTap,
              onChanged: onChanged,
            ),
          ),
          if (suffixIcon != null) suffixIcon! else const SizedBox(),
        ],
      ),
    );
  }
}
