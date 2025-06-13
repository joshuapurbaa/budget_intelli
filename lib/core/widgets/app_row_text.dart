import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class RowText extends StatelessWidget {
  const RowText({
    required this.left,
    required this.right,
    this.styleTypeLeft,
    this.styleTypeRight,
    this.fontWeightLeft,
    this.fontStyleLeft,
    this.fontWeightRight,
    super.key,
  });

  final String left;
  final String right;
  final StyleType? styleTypeLeft;
  final StyleType? styleTypeRight;
  final FontWeight? fontWeightLeft;
  final FontWeight? fontWeightRight;
  final FontStyle? fontStyleLeft;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppText(
            text: left,
            fontWeight: fontWeightLeft ?? FontWeight.w600,
            style: styleTypeLeft ?? StyleType.bodMed,
            fontStyle: fontStyleLeft ?? FontStyle.normal,
          ),
        ),
        AppText(
          text: right,
          style: styleTypeRight ?? StyleType.bodMed,
          fontWeight: fontWeightRight ?? FontWeight.w400,
        ),
      ],
    );
  }
}
