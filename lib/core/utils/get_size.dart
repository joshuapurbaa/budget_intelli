import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double getWidth(double width) {
  return width.w;
}

double getHeight(double height) {
  return height.w;
}

Size getSize({required double width, required double height}) {
  return Size(width, height);
}
