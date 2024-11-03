import 'package:budget_intelli/core/core.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
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
                shape: const RoundedRectangleBorder(
                  
                ),
                content: SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: EasyDateTimeLine(
                    initialDate: DateTime.now(),
                    onDateChange: (selectedDate) {
                      //`selectedDate` the new date selected.
                    },
                    headerProps: EasyHeaderProps(
                      selectedDateStyle: TextStyle(
                        color: context.color.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    activeColor: context.color.primary,
                    dayProps: EasyDayProps(
                      todayHighlightStyle: TodayHighlightStyle.withBackground,
                      todayHighlightColor: context.color.primary,
                      activeDayStyle: DayStyle(
                        dayNumStyle: textStyle(
                          context,
                          StyleType.disMd,
                        ).copyWith(
                          color: context.color.onPrimary,
                        ),
                        monthStrStyle: textStyle(
                          context,
                          StyleType.bodSm,
                        ).copyWith(
                          color: context.color.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        dayStrStyle: textStyle(
                          context,
                          StyleType.bodSm,
                        ).copyWith(
                          color: context.color.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      inactiveDayStyle: DayStyle(
                        dayNumStyle: textStyle(
                          context,
                          StyleType.bodLg,
                        ),
                      ),
                      todayStyle: DayStyle(
                        dayNumStyle: textStyle(
                          context,
                          StyleType.bodLg,
                        ).copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                insetPadding: EdgeInsets.zero,
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
