import 'package:budget_intelli/core/core.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart'
    show
        CalendarDatePicker2,
        CalendarDatePicker2Config,
        CalendarDatePicker2Mode,
        CalendarDatePicker2Type;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BoxCalender extends StatefulWidget {
  const BoxCalender({
    required this.categoriesType,
    required this.calendarType,
    super.key,
  });

  final CategoriesType categoriesType;
  final CalendarDatePicker2Type calendarType;

  @override
  State<BoxCalender> createState() => _BoxCalenderState();
}

class _BoxCalenderState extends State<BoxCalender> {
  GlobalKey actionKey = GlobalKey();

  String _boxLabel(List<DateTime>? selectedDates, BuildContext context) {
    final localize = textLocalizer(context);

    switch (widget.categoriesType) {
      case CategoriesType.expenses:
        if (selectedDates != null && selectedDates.isNotEmpty) {
          return formatDateDDMMYYYY(
            selectedDates[0],
            context,
          );
        } else {
          return '${localize.dateFieldLabel}*';
        }
      case CategoriesType.income:
        if (selectedDates != null && selectedDates.length == 2) {
          return formatDateRangeStr(
            selectedDates.map((e) => e.toString()).toList(),
            context,
          );
        } else if (selectedDates != null && selectedDates.isNotEmpty) {
          return formatDateDDMMYYYY(
            selectedDates[0],
            context,
          );
        } else {
          return '${localize.periodFieldLabel}*';
        }
      case CategoriesType.schedulePayment:
        if (selectedDates != null && selectedDates.isNotEmpty) {
          return formatDateDDMMYYYY(
            selectedDates[0],
            context,
          );
        } else {
          return '${localize.dueDateFieldLabel}*';
        }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<BoxCalendarCubit>().setToInitial(widget.calendarType);
  }

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoxCalendarCubit, BoxCalendarState>(
      builder: (context, state) {
        Widget? text;
        if (state is DateSelected) {
          text = AppText.bold14(
            text: _boxLabel(state.dates, context),
          );
        } else if (state is DateRangeSelected) {
          text = AppText.bold14(
            text: _boxLabel(state.dates, context),
          );
        } else {
          text = AppText.color(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            style: StyleType.bodMd,
            fontWeight: FontWeight.w500,
            text: _boxLabel(null, context),
          );
        }

        return GestureDetector(
          onTap: _showPopupMenu,
          child: AppGlass(
            // boxShadow: appBoxShadow(context),
            // border: appBorder(context),
            height: 70.h,
            child: Row(
              children: [
                getSvgAsset(
                  dateCalender,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap.horizontal(16),
                Expanded(
                  child: text,
                ),
                Gap.horizontal(16),
                getSvgAsset(
                  isExpanded ? chevronDown : chevronRight,
                  key: actionKey,
                  width: 18,
                  height: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap.horizontal(10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPopupMenu() {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    showMenu<String>(
      context: context,
      position: getRelativeRectPosition(context, actionKey),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16).r,
      ),
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.ease,
        reverseCurve: Curves.ease,
        duration: const Duration(milliseconds: 100),
      ),
      color: Theme.of(context).colorScheme.onTertiary,
      items: [
        PopupMenuItem(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width - 32,
            height: 200.h,
            child: BlocBuilder<BoxCalendarCubit, BoxCalendarState>(
              builder: (context, state) {
                CalendarDatePicker2Type? calendarType;
                List<DateTime?> value;
                if (state is BoxCalendarInitial) {
                  calendarType = state.calendarType;
                  value = [];
                } else {
                  calendarType = widget.calendarType;
                  value = state is DateSelected
                      ? state.dates
                      : state is DateRangeSelected
                          ? state.dates
                          : [];
                }

                final firstDate = DateTime.now().subtract(
                  const Duration(days: 30),
                );

                return CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    controlsHeight: 50.h,
                    customModePickerIcon: const Icon(
                      CupertinoIcons.chevron_down,
                      size: 15,
                    ),
                    controlsTextStyle: textStyle(
                      context,
                      StyleType.bodSm,
                    ),
                    calendarViewMode: CalendarDatePicker2Mode.day,
                    centerAlignModePicker: false,
                    firstDate: firstDate,
                    lastDate: DateTime.now().add(
                      const Duration(days: 365),
                    ),
                    calendarType: calendarType,
                  ),
                  value: value,
                  onValueChanged: (dates) {
                    if (widget.categoriesType ==
                            CategoriesType.schedulePayment ||
                        widget.categoriesType == CategoriesType.expenses) {
                      context.read<BoxCalendarCubit>().selectSingleDate(dates);
                      context.pop();
                      FocusScope.of(context).unfocus();
                    } else if (widget.categoriesType == CategoriesType.income) {
                      context.read<BoxCalendarCubit>().selectDateRange(dates);
                      if (dates.length == 2) {
                        context.pop();
                        FocusScope.of(context).unfocus();
                      }
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
