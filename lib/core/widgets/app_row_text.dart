import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RowText extends StatelessWidget {
  const RowText({
    required this.left,
    required this.right,
    this.styleTypeLeft,
    this.styleTypeRight,
    this.fontWeightLeft,
    this.fontStyleLeft,
    this.fontWeightRight,
    this.lineThrough,
    this.showAmount = true,
    super.key,
  });

  final String left;
  final String right;
  final StyleType? styleTypeLeft;
  final StyleType? styleTypeRight;
  final FontWeight? fontWeightLeft;
  final FontWeight? fontWeightRight;
  final FontStyle? fontStyleLeft;
  final bool? lineThrough;
  final bool showAmount;

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
            lineThrough: lineThrough,
          ),
        ),
        if (showAmount)
          AppText(
            text: right,
            style: styleTypeRight ?? StyleType.bodMed,
            fontWeight: fontWeightRight ?? FontWeight.w400,
            lineThrough: lineThrough,
          )
        else
          Icon(
            FontAwesomeIcons.ellipsis,
            color: context.color.primary,
            size: 35,
          ),
      ],
    );
  }
}
