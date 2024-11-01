import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppShimmerWidget extends StatelessWidget {
  const AppShimmerWidget({
    super.key,
    this.one,
    this.circle = false,
    this.height,
    this.width,
    this.cardSlider,
    this.padding,
  });

  const AppShimmerWidget.circle({
    super.key,
    this.one,
    this.height,
    this.width,
    this.cardSlider,
    this.padding,
  }) : circle = true;

  const AppShimmerWidget.one({
    super.key,
    this.circle,
    this.height,
    this.width,
    this.cardSlider,
    this.padding,
  }) : one = true;

  const AppShimmerWidget.cardSlider({
    super.key,
    this.height,
    this.width,
    this.circle,
    this.one,
    this.padding,
  }) : cardSlider = true;

  final bool? circle;
  final bool? one;
  final double? height;
  final double? width;
  final bool? cardSlider;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (cardSlider != null) {
      return SingleChildScrollView(
        padding: getEdgeInsets(left: 16, right: 16),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AppShimmer(
              height: (height ?? 50).h,
              width: (width ?? 50).w,
              borderRadius: 16,
            ),
            Gap.horizontal(10),
            AppShimmer(
              height: (height ?? 50).h,
              width: (width ?? 50).w,
              borderRadius: 16,
            ),
            Gap.horizontal(10),
            AppShimmer(
              height: (height ?? 50).h,
              width: (width ?? 50).w,
              borderRadius: 16,
            ),
          ],
        ),
      );
    }

    if (one != null) {
      return Padding(
        padding: padding ?? getEdgeInsetsAll(16),
        child: AppShimmer(
          height: height ?? 50,
          width: double.infinity,
          borderRadius: 16,
        ),
      );
    }

    if (circle != null) {
      return Row(
        children: [
          const AppShimmer(
            height: 50,
            width: 50,
            borderRadius: 25,
          ),
          Gap.horizontal(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppShimmer(
                  height: 20,
                  width: 150,
                ),
                Gap.vertical(8),
                const AppShimmer(
                  height: 20,
                  width: 100,
                ),
              ],
            ),
          ),
          Gap.horizontal(16),
          Column(
            children: [
              const AppShimmer(
                height: 20,
                width: 50,
              ),
              Gap.vertical(8),
              const AppShimmer(
                height: 20,
                width: 50,
              ),
            ],
          ),
        ],
      );
    }
    return Row(
      children: [
        const AppShimmer(
          height: 50,
          width: 50,
        ),
        Gap.horizontal(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppShimmer(
                height: 20,
                width: 150,
              ),
              Gap.vertical(8),
              const AppShimmer(
                height: 20,
                width: 100,
              ),
            ],
          ),
        ),
        Gap.horizontal(16),
        const AppShimmer(
          height: 50,
          width: 50,
        ),
      ],
    );
  }
}
