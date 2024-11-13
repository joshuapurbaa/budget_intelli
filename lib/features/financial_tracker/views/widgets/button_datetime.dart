import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonDateTime extends StatelessWidget {
  const ButtonDateTime({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TimeScrollWheelCubit>().state;
    final localize = textLocalizer(context);
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
                shape: const RoundedRectangleBorder(),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EasyDateTimeLine(
                        initialDate: DateTime.now(),
                        onDateChange: (date) {
                          final dateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            int.parse(state.selectedHour),
                            int.parse(state.selectedMinute),
                          );
                          context
                              .read<TimeScrollWheelCubit>()
                              .setSelectedDate(dateTime);
                        },
                        headerProps: EasyHeaderProps(
                          selectedDateStyle: TextStyle(
                            color: context.color.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        activeColor: context.color.primary,
                        dayProps: EasyDayProps(
                          todayHighlightStyle: TodayHighlightStyle.none,
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
                      Gap.vertical(16),
                      AppText(
                        text: localize.at,
                        style: StyleType.bodLg,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        padding: getEdgeInsetsSymmetric(horizontal: 80),
                        child: Stack(
                          children: [
                            const TimeScrollWheel(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: BlocBuilder<TimeScrollWheelCubit,
                                  TimeScrollWheelState>(
                                builder: (context, state) {
                                  return AppText(
                                    text: state.period,
                                    style: StyleType.bodLg,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
        decoration: BoxDecoration(
          color: context.color.onInverseSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Padding(
              padding: getEdgeInsetsAll(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getSvgAsset(dateCalender),
                  Gap.horizontal(10),
                  Expanded(
                    child: AppText(
                      text: formatDateDDMMYYYY(
                        state.selectedDate,
                        context,
                      ),
                      style: StyleType.bodLg,
                      color: context.color.onSurface,
                      fontWeight: FontWeight.w400,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: context.color.surfaceTint.withOpacity(0.6),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: AppText(
                  text:
                      '${state.selectedHour}:${state.selectedMinute} ${state.period}',
                  style: StyleType.bodSm,
                  color: context.color.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
