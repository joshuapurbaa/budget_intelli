import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Gap {
  Gap._();

  static SizedBox horizontal(double size) => SizedBox(width: size.w);
  static SizedBox vertical(double size) => SizedBox(height: size.h);
}
