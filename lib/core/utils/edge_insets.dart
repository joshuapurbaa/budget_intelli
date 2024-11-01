import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

EdgeInsetsGeometry getEdgeInsets({
  double top = 0,
  double right = 0,
  double bottom = 0,
  double left = 0,
}) {
  return EdgeInsets.fromLTRB(left, top, right, bottom).r;
}

EdgeInsetsGeometry getEdgeInsetsSymmetric({
  double vertical = 0,
  double horizontal = 0,
}) {
  return EdgeInsets.symmetric(
    vertical: vertical,
    horizontal: horizontal,
  ).r;
}

EdgeInsetsGeometry getEdgeInsetsAll(double value) {
  return EdgeInsets.all(value).w;
}
