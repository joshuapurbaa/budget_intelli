import 'package:calendar_date_picker2/calendar_date_picker2.dart'
    show CalendarDatePicker2Type;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'box_calendar_state.dart';

class BoxCalendarCubit extends Cubit<BoxCalendarState> {
  BoxCalendarCubit()
      : super(
          BoxCalendarInitial(
            calendarType: CalendarDatePicker2Type.single,
          ),
        );

  void setToInitial(CalendarDatePicker2Type calendarType) {
    emit(
      BoxCalendarInitial(calendarType: calendarType),
    );
  }

  void selectSingleDate(List<DateTime?>? date) {
    if (date != null) {
      emit(DateSelected(date.cast<DateTime>()));
    }
  }

  void selectDateRange(List<DateTime?>? dates) {
    if (dates != null) {
      emit(DateRangeSelected(dates.cast<DateTime>()));
    }
  }
}
