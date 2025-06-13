import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

TextStyle textStyle(BuildContext context, {StyleType? style}) {
  return AppTextStyle.style(context, style: style ?? StyleType.bodMed);
}
