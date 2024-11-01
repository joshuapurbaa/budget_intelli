import 'package:flutter/material.dart';

BoxDecoration setBoxDecoration({
  required bool cornerAll,
  Color? color,
  BorderRadius? borderRadius,
  double radius = 8,
  Gradient? gradient,
  BoxBorder? border,
  List<BoxShadow>? boxShadow,
  BoxShape? shape,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: cornerAll ? BorderRadius.circular(radius) : borderRadius,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    shape: shape ?? BoxShape.rectangle,
  );
}
