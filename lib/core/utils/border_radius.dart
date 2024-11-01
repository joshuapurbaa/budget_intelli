import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

BorderRadiusGeometry getRadius(double radius) {
  return BorderRadius.circular(radius).w;
}

BorderRadiusGeometry getRadiusTop(double radius) {
  return BorderRadius.only(
    topLeft: Radius.circular(radius),
    topRight: Radius.circular(radius),
  ).w;
}

BorderRadiusGeometry getRadiusBottom(double radius) {
  return BorderRadius.only(
    bottomLeft: Radius.circular(radius),
    bottomRight: Radius.circular(radius),
  ).w;
}

BorderRadiusGeometry getRadiusTopLeft(double radius) {
  return BorderRadius.only(
    topLeft: Radius.circular(radius),
  ).w;
}

BorderRadiusGeometry getRadiusTopRight(double radius) {
  return BorderRadius.only(
    topRight: Radius.circular(radius),
  ).w;
}

BorderRadiusGeometry getRadiusBottomLeft(double radius) {
  return BorderRadius.only(
    bottomLeft: Radius.circular(radius),
  ).w;
}

BorderRadiusGeometry getRadiusBottomRight(double radius) {
  return BorderRadius.only(
    bottomRight: Radius.circular(radius),
  ).w;
}

BorderRadiusGeometry getRadiusHorizontal(double radius) {
  return BorderRadius.only(
    topLeft: Radius.circular(radius),
    bottomLeft: Radius.circular(radius),
  ).w;
}

BorderRadiusGeometry getRadiusVertical(double radius) {
  return BorderRadius.only(
    topLeft: Radius.circular(radius),
    topRight: Radius.circular(radius),
  ).w;
}
