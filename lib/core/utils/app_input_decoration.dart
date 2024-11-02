import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

InputDecoration appInputDecoration(
  BuildContext context, {
  required String hintText,
  required String prefixIcon,
  String? suffixIcon,
  BorderSide? borderSide,
  double? radiusCircular,
  Color? fillColor,
  VoidCallback? onTapSuffixIcon,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  return InputDecoration(
    contentPadding: const EdgeInsets.all(20),
    hintText: hintText,
    hintStyle: AppTextStyle.style(
      context,
      style: StyleType.bodMd,
    ).copyWith(
      color: colorScheme.onSurfaceVariant,
    ),
    prefixIcon: Padding(
      padding: const EdgeInsets.all(20),
      child: getSvgAsset(
        prefixIcon,
        width: 20,
        color: colorScheme.onSurface,
      ),
    ),
    suffixIcon: suffixIcon != null
        ? GestureDetector(
            onTap: onTapSuffixIcon,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: getPngAsset(
                suffixIcon,
                width: 20,
                color: context.color.onSurface,
              ),
            ),
          )
        : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusCircular ?? 10),
      borderSide: borderSide ?? BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusCircular ?? 10),
      borderSide: borderSide ?? BorderSide.none,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusCircular ?? 10),
      borderSide: borderSide ?? BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusCircular ?? 10),
      borderSide: borderSide ?? BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusCircular ?? 10),
      borderSide: BorderSide(
        color: colorScheme.error,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusCircular ?? 10),
      borderSide: BorderSide(
        color: colorScheme.error,
      ),
    ),
    filled: true,
    fillColor: fillColor ?? colorScheme.onInverseSurface,
  );
}
