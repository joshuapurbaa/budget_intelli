import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart' show Lottie;
import 'package:rive/rive.dart' show RiveAnimation;

Widget getSvgAsset(
  String path, {
  double width = 24,
  double height = 24,
  Color? color,
  Key? key,
}) {
  return SizedBox(
    key: key,
    width: width.w,
    height: height.h,
    child: SvgPicture.asset(
      path,
      color: color,
    ),
  );
}

Image getPngAsset(
  String path, {
  double width = 24,
  double height = 24,
  BoxFit fit = BoxFit.contain,
  int? cacheHeight,
  int? cacheWidth,
  Color? color,
}) {
  return Image.asset(
    path,
    cacheHeight: cacheHeight,
    cacheWidth: cacheWidth,
    width: width.w,
    height: height.h,
    fit: fit,
    color: color,
  );
}

Widget getLottieAsset(
  String path, {
  double width = 24,
  double height = 24,
  BoxFit fit = BoxFit.contain,
  bool reverse = false,
  bool repeat = true,
  bool animate = true,
  Key? key,
}) {
  return SizedBox(
    key: key,
    width: width.w,
    height: height.h,
    child: Lottie.asset(
      path,
      width: width.w,
      height: height.h,
      fit: fit,
      repeat: repeat,
      reverse: reverse,
      animate: animate,
    ),
  );
}

Widget getRivAsset(
  String path, {
  double width = 24,
  double height = 24,
  BoxFit fit = BoxFit.contain,
  Key? key,
}) {
  return SizedBox(
    key: key,
    width: width.w,
    height: height.h,
    child: RiveAnimation.asset(
      path,
      fit: fit,
    ),
  );
}
