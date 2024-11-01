import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

/// should have stack as parent
class AppTransformer extends StatelessWidget {
  const AppTransformer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      left: 0,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.005)
          ..rotateZ(0.04),
        alignment: FractionalOffset.center,
        child: Container(
          margin: getEdgeInsetsAll(2),
          decoration: BoxDecoration(
            color: AppColor.transparent,
            borderRadius: getRadius(16),
            border: appBorder(context),
          ),
        ),
      ),
    );
  }
}
