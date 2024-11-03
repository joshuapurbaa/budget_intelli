import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class ButtonDateTime extends StatelessWidget {
  const ButtonDateTime({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black54,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (
            BuildContext buildContext,
            animation,
            secondaryAnimation,
          ) {
            return Center(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                content: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                ),
                insetPadding: EdgeInsets.symmetric(horizontal: 0),
              ),
            );
          },
          transitionBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        );
      },
      child: Container(
        alignment: Alignment.center,
        padding: getEdgeInsetsAll(12),
        decoration: BoxDecoration(
          color: context.color.onInverseSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getSvgAsset(dateCalender),
            Gap.horizontal(8),
            AppText(
              text: '03 Nov 2024',
              style: StyleType.bodLg,
              color: context.color.onSurface,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
