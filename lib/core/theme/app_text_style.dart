import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  AppTextStyle._();
  static final textThemeDarkMode = TextTheme(
    /// headline 1 = H1
    displayLarge: TextStyle(
      fontSize: 48.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    /// headline 2 = H2
    displayMedium: TextStyle(
      fontSize: 40.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    /// headline 3 = H3
    displaySmall: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    /// headline 4 = H4
    headlineLarge: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Urbanist',
    ),

    /// headline 5 = H5
    headlineMedium: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Urbanist',
    ),

    /// headline 6 = H6
    headlineSmall: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Urbanist',
    ),

    ///body Xlarge = xLarge
    titleLarge: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    titleMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Urbanist',
    ),

    titleSmall: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Urbanist',
    ),

    /// body large = large
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    /// body medium = medium
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Urbanist',
    ),

    /// body small = small
    bodySmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Urbanist',
    ),

    /// body xsmall = xSmall
    labelLarge: TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Urbanist',
    ),

    labelMedium: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Urbanist',
    ),

    labelSmall: TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Urbanist',
    ),
  );

  static final textThemeLightMode = TextTheme(
    /// headline 1
    displayLarge: TextStyle(
      fontSize: 48.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    /// headline 2
    displayMedium: TextStyle(
      fontSize: 40.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    /// headline 3
    displaySmall: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    /// headline 4
    headlineLarge: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Urbanist',
    ),

    /// headline 5
    headlineMedium: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Urbanist',
    ),

    /// headline 6
    headlineSmall: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Urbanist',
    ),

    ///body Xlarge
    titleLarge: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    titleMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Urbanist',
    ),

    titleSmall: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Urbanist',
    ),

    /// body large
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    /// body medium
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    /// body small
    bodySmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    /// body xsmall
    labelLarge: TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    labelMedium: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),

    labelSmall: TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Urbanist',
    ),
  );

  static TextStyle style(BuildContext context, {required StyleType style}) {
    switch (style) {
      case StyleType.disLg:
        return Theme.of(context).textTheme.displayLarge!;
      case StyleType.disMd:
        return Theme.of(context).textTheme.displayMedium!;
      case StyleType.disSm:
        return Theme.of(context).textTheme.displaySmall!;
      case StyleType.headLg:
        return Theme.of(context).textTheme.headlineLarge!;
      case StyleType.headMed:
        return Theme.of(context).textTheme.headlineMedium!;
      case StyleType.headSm:
        return Theme.of(context).textTheme.headlineSmall!;
      case StyleType.titLg:
        return Theme.of(context).textTheme.titleLarge!;
      case StyleType.titMd:
        return Theme.of(context).textTheme.titleMedium!;
      case StyleType.titSm:
        return Theme.of(context).textTheme.titleSmall!;
      case StyleType.bodLg:
        return Theme.of(context).textTheme.bodyLarge!;
      case StyleType.bodMed:
        return Theme.of(context).textTheme.bodyMedium!;
      case StyleType.bodSm:
        return Theme.of(context).textTheme.bodySmall!;
      case StyleType.labLg:
        return Theme.of(context).textTheme.labelLarge!;
      case StyleType.labMd:
        return Theme.of(context).textTheme.labelMedium!;
      case StyleType.labSm:
        return Theme.of(context).textTheme.labelSmall!;
    }
  }
}
