part of 'box_calendar_cubit.dart';

@immutable
sealed class BoxCalendarState {}

final class BoxCalendarInitial extends BoxCalendarState {
  BoxCalendarInitial({required this.calendarType});

  final CalendarDatePicker2Type calendarType;
}

final class DateSelected extends BoxCalendarState {
  DateSelected(this.dates);
  final List<DateTime> dates;
}

final class DateRangeSelected extends BoxCalendarState {
  DateRangeSelected(this.dates);
  final List<DateTime> dates;
}
